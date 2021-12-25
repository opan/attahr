module Main
  module Controllers
    module Products
      class Update
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :product
        expose :product_categories

        params do
          required(:id).filled
          required(:product).schema do
            required(:name).filled(:str?)
            optional(:sku).maybe(:str?)
            required(:price).filled(:int?)
            required(:product_category_id).filled
          end
        end

        def initialize(
          product_repo: ProductRepository.new,
          product_category_repo: ProductCategoryRepository.new,
          org_repo: OrgRepository.new
        )
          @product_repo = product_repo
          @product_category_repo = product_category_repo
          @org_repo = org_repo
        end

        def call(params)
          @product = @product_repo.find(params[:id])
          root_org = @org_repo.find_root_org_by_member(current_user.profile.id)
          @product_categories = @product_category_repo.find_by_root_org(root_org.id)

          if @product.nil?
            flash[:errors] = ["Can't find product with ID #{params[:id]}"]
            redirect_to Main.routes.products_path
          end

          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          update_product = Product.new(product_params)

          unless @product_categories.map(&:id).include? update_product.product_category_id
            flash[:errors] = ["Can't find product category with ID #{update_product.product_category_id}"]
            redirect_to Main.routes.products_path
          end

          if update_product.sku.nil? || update_product.sku.empty?
            flash[:errors] = ["SKU can't be set to empty"]
            self.status = 422
            return
          end

          @product_repo.transaction do
            @product = @product_repo.update(@product.id, update_product)
          end

          flash[:info] = ['Product has been successfully updated']
          redirect_to Main.routes.products_path
        end

        private

        def product_params
          params.get(:product)
        end
      end
    end
  end
end

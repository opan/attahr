module Main
  module Controllers
    module ProductCategories
      class Update
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :product_category

        params do
          required(:id).filled
          required(:product_category).schema do
            required(:name).filled(:str?)
          end
        end

        def initialize(
          product_category_repo: ProductCategoryRepository.new,
          org_repo: OrgRepository.new
        )
          @product_category_repo = product_category_repo
          @org_repo = org_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          root_org = @org_repo.find_root_org_by_member(current_user.profile.id)
          if root_org.nil?
            flash[:errors] = ["Can't find root organization for current user"]
            redirect_to Main.routes.product_categories_path
          end

          product_category = @product_category_repo.find(params[:id])

          if product_category.nil?
            flash[:errors] = ["Can't find product category with ID #{params[:id]}"]
            redirect_to Main.routes.products_path
          end

          update_category = ProductCategory.new(category_params)

          @product_category_repo.transaction do
            @product_category = @product_category_repo.update(product_category.id, update_category)
          end

          flash[:info] = ['Product category has been successfully updated']
          redirect_to Main.routes.product_categories_path
        end

        private

        def category_params
          params.get(:product_category)
        end
      end
    end
  end
end

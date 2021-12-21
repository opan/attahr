module Main
  module Controllers
    module Products
      class Create
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :product

        params do
          required(:product).schema do
            required(:name).filled(:str?)
            optional(:sku).maybe(:str?)
            required(:price).filled(:int?)
            required(:product_category_id).filled
          end
        end

        def initialize(
          product_repo: ProductRepository.new,
          product_org_repo: ProductOrgRepository.new,
          org_member_repo: OrgMemberRepository.new,
          org_repo: OrgRepository.new
        )
          @product_repo = product_repo
          @product_org_repo = product_org_repo
          @org_member_repo = org_member_repo
          @org_repo = org_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          orgs = @org_repo.all_by_member(current_user.profile.id)
          root_org = orgs.select { |o| o.is_root == true }.first
          if root_org.nil?
            flash[:errors] = ["Can't find root organization for current user"]
            redirect_to Main.routes.products_path
          end

          sku = product_params[:sku]
          product_entity = Product.new(product_params)

          if sku_empty?(sku)
            sku = "SKU-#{random_sku}"
            product_entity = Product.new(product_params.merge({sku: sku}))
          end

          duplicate_sku = @product_repo.find_by_sku_and_org(product_entity.sku, root_org.id)

          if duplicate_sku
            flash[:errors] = ["Found duplicate SKU: #{product_entity.sku}"]
            self.status = 422
            return
          end

          @product_repo.transaction do
            @product = @product_repo.create(product_entity)
            @product_org_repo.create(ProductOrg.new(product_id: @product.id, org_id: root_org.id)) unless @product.nil?
          end

          flash[:info] = ["Product #{product_params[:name]} has been successfully created"]
          redirect_to Main.routes.products_path
        end

        private

        def product_params
          params.get(:product).merge({ created_by_id: current_user.id, updated_by_id: current_user.id })
        end

        def sku_empty?(sku)
          sku.nil? || sku.empty?
        end

        def random_sku
          [*('a'..'z'), *('0'..'9')].sample(8).join.upcase
        end
      end
    end
  end
end

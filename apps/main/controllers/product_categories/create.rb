module Main
  module Controllers
    module ProductCategories
      class Create
        include Main::Action
        include Main::Authentication

        before :authenticate!

        params do
          required(:product_category).schema do
            required(:name).filled(:str?)
          end
        end

        def initialize(
          product_category_repo: ProductCategoryRepository.new,
          product_category_org_repo: ProductCategoryOrgRepository.new,
          org_repo: OrgRepository.new
        )
          @product_category_repo = product_category_repo
          @product_category_org_repo = product_category_org_repo
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

          product_category = ProductCategory.new(params_category)
          duplicate_category = @product_category_repo.find_by_name_and_root_org(product_category.name, root_org.id)
          unless duplicate_category.nil?
            flash[:errors] = ["Duplicate product category #{product_category.name} in organization #{root_org.display_name}"]
            redirect_to Main.routes.product_categories_path
          end

          @product_category_repo.transaction do
            category = @product_category_repo.create(product_category)
            category_org = ProductCategoryOrg.new(product_category_id: category.id, org_id: root_org.id)
            @product_category_org_repo.create(category_org)
          end

          flash[:info] = ['Product category has been successfully created']
          redirect_to Main.routes.product_categories_path
        end

        private

        def params_category
          params.get(:product_category)
        end
      end
    end
  end
end

module Main
  module Controllers
    module ProductCategories
      class Destroy
        include Main::Action
        include Main::Authentication

        before :authenticate!

        params do
          required(:id).filled
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
            flash[:errors] = params.errors_messages
            redirect_to Main.routes.products_path
          end

          root_org = @org_repo.find_root_org_by_member(current_user.profile.id)
          if root_org.nil?
            flash[:errors] = ["Can't find root organization for current user"]
            redirect_to Main.routes.product_categories_path
          end

          category = @product_category_repo.find(params[:id])
          if category.nil?
            flash[:errors] = ["Can't find product category with ID #{params[:id]}"]
            redirect_to Main.routes.product_categories_path
          end

          @product_category_repo.transaction do
            @product_category_repo.delete(category.id)
            @product_category_org_repo.delete_by_category(category.id)
          end

          flash[:info] = ['Product category has been successfully deleted']
          redirect_to Main.routes.product_categories_path
        end
      end
    end
  end
end

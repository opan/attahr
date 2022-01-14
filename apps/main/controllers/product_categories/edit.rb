module Main
  module Controllers
    module ProductCategories
      class Edit
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :product_category

        params do
          required(:id).filled
        end

        def initialize(product_category_repo: ProductCategoryRepository.new, org_repo: OrgRepository.new)
          @product_category_repo = product_category_repo
          @org_repo = org_repo
        end

        def call(_)
          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          root_org = @org_repo.find_root_org_by_member(current_user.profile.id)
          if root_org.nil?
            flash[:errors] = ["You don't have relation to any organization"]
            redirect_to Main.routes.product_categories_path
          end

          @product_category = @product_category_repo.find(params[:id])
          if @product_category.nil?
            flash[:errors] = ['Invalid ID']
            self.status = 422
          end
        end
      end
    end
  end
end

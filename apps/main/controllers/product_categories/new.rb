module Main
  module Controllers
    module ProductCategories
      class New
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :product_category

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(_)
          root_org = @org_repo.find_root_org_by_member(current_user.profile.id)
          if root_org.nil?
            flash[:errors] = ["You don't have relation to any organization"]
            redirect_to Main.routes.product_categories_path
          end
          @product_category = ProductCategory.new
        end
      end
    end
  end
end

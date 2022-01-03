module Main
  module Controllers
    module ProductCategories
      class Index
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :product_categories

        def initialize(product_category_repo: ProductCategoryRepository.new, org_repo: OrgRepository.new)
          @product_category_repo = product_category_repo
          @org_repo = org_repo
        end

        def call(_)
          root_org = @org_repo.find_root_org_by_member(current_user.profile.id)
          @product_categories = @product_category_repo.find_by_root_org(root_org.id)
        end
      end
    end
  end
end

module Main
  module Controllers
    module Products
      class New
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :product
        expose :product_categories

        def initialize(product_category_repo: ProductCategoryRepository.new, org_member_repo: OrgMemberRepository.new)
          @product_category_repo = product_category_repo
          @org_member_repo = org_member_repo
        end

        def call(_)
          org_members = @org_member_repo.find_by_emails([current_user.email])
          @product_categories = @product_category_repo.find_by_orgs(org_members.map(&:org_id))
          @product = Product.new(price: 0)
        end
      end
    end
  end
end

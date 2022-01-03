module Main
  module Controllers
    module Products
      class Index
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :products

        def initialize(product_repo: ProductRepository.new, org_member_repo: OrgMemberRepository.new)
          @product_repo = product_repo
          @org_member_repo = org_member_repo
        end

        def call(_)
          org_members = @org_member_repo.find_by_emails([current_user.email])
          @products = @product_repo.find_by_orgs(org_members.map(&:org_id))
        end
      end
    end
  end
end

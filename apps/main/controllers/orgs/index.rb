module Main
  module Controllers
    module Orgs
      class Index
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :orgs
        expose :root_org

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(_)
          @orgs = @org_repo.all_by_member(current_user.profile.id)
          @root_org = @orgs.select { |o| o.is_root == true }.first
        end
      end
    end
  end
end

module Main
  module Controllers
    module Orgs
      class New
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :org
        expose :parent_id

        def initialize(org_repo: OrgRepository.new)
          @org_repo ||= org_repo
        end

        def call(_)
          @org = Org.new
          root_org = @org_repo.find_root_org_by_member(current_user.profile.id)
          @parent_id = root_org.id unless root_org.nil?
        end
      end
    end
  end
end

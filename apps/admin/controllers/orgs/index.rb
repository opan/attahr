module Admin
  module Controllers
    module Orgs
      class Index
        include Admin::Action
        include Main::Authentication

        before :authenticate!

        expose :orgs

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(params)
          if superadmin_user?
            @orgs = @org_repo.all
          else
            @orgs = @org_repo.all_by_member(current_user.profile.id)
          end
        end
      end
    end
  end
end

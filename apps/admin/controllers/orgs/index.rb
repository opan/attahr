module Admin
  module Controllers
    module Orgs
      class Index
        include Admin::Action
        include Admin::Authentication

        before :authenticate!

        expose :orgs

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(params)
          @orgs = @org_repo.all_by_member(current_user.profile.id)
        end
      end
    end
  end
end

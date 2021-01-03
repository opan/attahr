module Web
  module Controllers
    module Orgs
      class Index
        include Web::Action
        include Web::Authentication

        before :authenticate!

        expose :orgs

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(params)
          @orgs = @org_repo.find_by_member(current_user.profile.id)
        end
      end
    end
  end
end

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
          redirect_to Main.routes.root_path unless superadmin_user?
          @orgs = @org_repo.all
        end
      end
    end
  end
end

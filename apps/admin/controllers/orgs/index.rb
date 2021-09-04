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
          unless superadmin_user?
            flash[:errors] = ["You're not allowed to access this page"]
            redirect_to Main.routes.root_path
          end

          @orgs = @org_repo.all
        end
      end
    end
  end
end

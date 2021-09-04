module Admin
  module Controllers
    module Orgs
      class Destroy
        include Admin::Action
        include Main::Authentication

        before :authenticate!

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(params)
          unless superadmin_user?
            flash[:errors] = ["You're not allowed to access this page"]
            redirect_to Main.routes.root_path
          end

          org = @org_repo.find(params.get(:id))
          if org.nil?
            flash[:errors] = ['Organization not found']
            redirect_to routes.orgs_path
          end

          @org_repo.delete(org.id)
          flash[:info] = ['Organization has been successfully deleted']
          redirect_to routes.orgs_path
        end
      end
    end
  end
end

module Admin
  module Controllers
    module Orgs
      class Edit
        include Admin::Action
        include Main::Authentication

        before :authenticate!

        expose :org

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(params)
          if superadmin_user?
            @org = @org_repo.find(params[:id])
          else
            @org = @org_repo.find_by_id_and_member(params[:id], current_user.profile.id)
          end

          if @org.nil?
            flash[:errors] = ['Organization not found']
            redirect_to routes.orgs_path
          end
        end
      end
    end
  end
end

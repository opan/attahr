module Main
  module Controllers
    module Orgs
      class RemoveMembers
        include Main::Action
        include Main::Authentication

        before :authenticate!

        params do
          required(:id).filled(:int?)
          required(:member_id).filled(:int?)
        end

        def initialize(org_repo: OrgRepository.new, org_member_repo: OrgMemberRepository.new)
          @org_repo ||= org_repo
          @org_member_repo ||= org_member_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            redirect_to Main.routes.orgs_path
          end

          user_profile = current_user.profile

          unless @org_member_repo.is_admin?(params[:id], user_profile.id)
            flash[:errors] = ['You are not allowed to perform this action']
            redirect_to Main.routes.orgs_path
          end

          org = @org_repo.find(params[:id])
          if org.nil?
            flash[:errors] = ["Cannot find organization with ID [#{params.get(:id)}]"]
            redirect_to Main.routes.orgs_path
          end

          @org_member_repo.delete_by_org_and_user(org.id, params[:member_id])
          flash[:info] = ["User has been successfully removed from organization [#{org.display_name}]"]
          redirect_to Main.routes.members_org_path(org.id)
        end
      end
    end
  end
end

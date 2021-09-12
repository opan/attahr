module Main
  module Controllers
    module Orgs
      class Members
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :org
        expose :org_members

        params do
          required(:id).filled(:int?)
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

          unless @org_member_repo.is_admin?(params[:id], current_user.profile.id)
            flash[:errors] = ['You are not allowed to perform this action']
            redirect_to Main.routes.orgs_path
          end

          @org = @org_repo.find(params.get(:id))
          if @org.nil?
            flash[:errors] = ["Cannot find organization with ID [#{params.get(:id)}]"]
            redirect_to Main.routes.orgs_path
          end

          @org_members = @org_member_repo.find_by_org(@org.id)
        end
      end
    end
  end
end

module Main
  module Controllers
    module Orgs
      class InviteMembers
        include Main::Action

        params do
          required(:id).filled(:int?)
          required(:invite_members).schema do
            required(:users_email).filled(:str?, format?: /(\w+)(,\s*+)*/)
          end
        end

        def initialize(org_repo: OrgRepository.new, org_member_repo: OrgMemberRepository.new, org_invitation_repo: OrgInvitationRepository.new)
          @org_repo = org_repo
          @org_member_repo = org_member_repo
          @org_invitation_repo = org_invitation_repo
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

          users_email = params[:invite_members][:users_email]
          validate_users_email(users_email)

          timeout = OrgInvitation::TIMEOUT
          invite_data = OrgInvitation.new(
            org_id: org.id,
            invite_id: SecureRandom.uuid,
            invitees: users_email,
            inviter: current_user.email,
            timeout: Time.now + timeout
          )
          invite = @org_invitation_repo.create(invite_data)

          Mailers::InviteMembersOrg.deliver(users: users_email, org: org, invite: invite)

          flash[:info] = ['Invite has been sent to the users.']
          redirect_to Main.routes.members_org_path(org.id)
        end

        private

        def validate_users_email(users_email)
          invitee_orgs = @org_member_repo.find_by_emails(users_email)
          inviter_orgs = @org_member_repo.find_by_emails(current_user.email)
          map_inviter_orgs = inviter_orgs.map(&:org_id)

          allowed_orgs = invitee_orgs.map(&:org_id).all? { |org| map_inviter_orgs.include?(org) }

          if !invitee_orgs.empty? && !allowed_orgs
            flash[:errors] = ["One or more invited users has been a member in one or more organization where the inviter is not part of a member.\nYou're not allowed to invite these users"]
            redirect_to Main.routes.members_org_path(params[:id])
          end
        end
      end
    end
  end
end

module Admin
  module Controllers
    module Orgs
      class Create
        include Admin::Action
        include Main::Authentication

        before :authenticate!

        params do
          required(:org).schema do
            required(:name).filled(:str?)
            optional(:display_name).maybe(:str?)
            required(:address).filled(:str?)
            optional(:phone_numbers).maybe(:str?)
          end
        end

        def initialize(org_repo: OrgRepository.new, org_member_repo: OrgMemberRepository.new, org_member_role_repo: OrgMemberRoleRepository.new)
          @org_repo = org_repo
          @org_member_repo = org_member_repo
          @org_member_role_repo = org_member_role_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          org_entity = Org.new(org_params)
          if org_entity.display_name == "" || org_entity.display_name.nil?
            org_entity = Org.new(org_params.merge({display_name: org_entity.name}))
          end

          org = @org_repo.create(org_entity)
          member = OrgMember.new(
            org_id: org.id,
            profile_id: current_user.profile.id,
            org_member_role_id: @org_member_role_repo.get('admin').id)
          @org_member_repo.create(member)

          flash[:info] = ["Organization #{org.display_name} has been successfully created"]
          redirect_to routes.orgs_path(user_id: params[:user_id])
        end

        private

        def org_params
          org = params.get(:org)
          org[:created_by_id] = current_user.id
          org[:updated_by_id] = current_user.id

          org
        end
      end
    end
  end
end

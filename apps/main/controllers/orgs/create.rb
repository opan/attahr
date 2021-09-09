module Main
  module Controllers
    module Orgs
      class Create
        include Main::Action
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

        def initialize(
          org_repo: orgrepository.new,
          org_member_repo: orgmemberrepository.new,
          org_member_role_repo: orgmemberrolerepository.new
        )
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

          user_profile = current_user.profile

          orgs = @org_repo.all_by_member(user_profile.id)
          unless orgs.map(&:created_by_id).uniq.include? user_profile.id
            flash[:errors] = ["You've already registered as a member in an organization which are not created by you"]
            redirect_to Main.routes.orgs_path
          end

          if orgs.length >= 2
            flash[:errors] = ["You've reach the maximum allowed number to create a new organization"]
            redirect_to Main.routes.orgs_path
          end

          admin_role = @org_member_role_repo.get('admin')

          org_entity = Org.new(params.get(:org))
          if org_entity.display_name == "" || org_entity.display_name.nil?
            org_entity = Org.new(org_params.merge({display_name: org_entity.name}))
          end

          org = @org_repo.create(org_entity)

          org_member_entity = OrgMember.new(
            org_id: org.id,
            org_member_role_id: admin_role.id,
            profile_id: user_profile.id,
          )
          @org_member_repo.create(org_member_entity)

          flash[:info] = ["Organization #{org.name} has been successfully created"]
          redirect_to Main.routes.orgs_path
        end
      end
    end
  end
end

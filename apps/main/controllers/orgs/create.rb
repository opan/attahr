module Main
  module Controllers
    module Orgs
      class Create
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :org

        params do
          required(:org).schema do
            required(:name).filled(:str?)
            optional(:display_name).maybe(:str?)
            required(:address).filled(:str?)
            optional(:phone_numbers).maybe(:str?)
            optional(:parent_id).maybe(:int?)
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
          parent_id = org_params[:parent_id]

          orgs = @org_repo.all_by_member(user_profile.id)
          created_orgs = orgs.map(&:created_by_id).uniq
          root_org = orgs.select { |o| o.is_root == true }.first

          if !orgs.empty? && !created_orgs.include?(user_profile.id)
            flash[:errors] = ["You've already registered as a member in an organization which are not created by you"]
            redirect_to Main.routes.orgs_path
          end

          if orgs.length >= Org::MAX_ORG
            flash[:errors] = ["You've reach the maximum allowed number to create a new organization"]
            redirect_to Main.routes.orgs_path
          end

          if parent_id.nil? && !root_org.nil?
            flash[:errors] = ["You can't create more than one root organization. Missing parent ID to create sub-organization"]
            redirect_to Main.routes.orgs_path
          end

          validate_parent_org(parent_id) unless parent_id.nil?

          admin_role = @org_member_role_repo.get('admin')

          org_entity = Org.new(org_params)
          if org_entity.display_name == '' || org_entity.display_name.nil?
            org_entity = Org.new(org_params.merge({ display_name: org_entity.name }))
          end

          org_entity = Org.new(org_params.merge({ is_root: true })) if orgs.empty?

          @org_repo.transaction do
            @org = @org_repo.create(org_entity)

            org_member_entity = OrgMember.new(
              org_id: org.id,
              org_member_role_id: admin_role.id,
              profile_id: user_profile.id
            )
            @org_member_repo.create(org_member_entity)
          end

          flash[:info] = ["Organization #{@org.name} has been successfully created"]
          redirect_to Main.routes.orgs_path
        end

        private

        def org_params
          params.get(:org)
        end

        def validate_parent_org(parent_id)
          parent_org = @org_repo.find(parent_id)
          if parent_org.nil?
            flash[:errors] = ["Can't find parent organization with parent_id #{parent_id}"]
            redirect_to Main.routes.orgs_path
          end
        end
      end
    end
  end
end

module Main
  module Controllers
    module Orgs
      class Update
        include Main::Action
        include Main::Authentication

        before :authenticate!

        params do
          required(:id).filled
          required(:org).schema do
            required(:name).filled(:str?)
            optional(:display_name).maybe(:str?)
            required(:address).filled(:str?)
            optional(:phone_numbers).maybe(:str?)
          end
        end

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          org = @org_repo.find_by_id_and_member(params.get(:id), current_user.profile.id)
          if org.nil?
            flash[:errors] = ["Cannot find organization with ID [#{params.get(:id)}]"]
            redirect_to Main.routes.orgs_path
          end

          params[:org].merge!({ updated_by_id: current_user.profile.id })
          updated_org = Org.new(org.to_h.merge!(params[:org]))
          @org_repo.update(org.id, updated_org)

          flash[:info] = ['Organization has been successfully updated']
          redirect_to Main.routes.orgs_path
        end
      end
    end
  end
end

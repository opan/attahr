module Web
  module Controllers
    module Orgs
      class Update
        include Web::Action
        include Web::Authentication

        before :authenticate!

        params do
          required(:id).filled(:int?)
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

          @org = @org_repo.find(params.get(:id))
          if @org.nil?
            flash[:errors] = ['Organization not found']
            self.status = 404
            return
          end

          org_entity = Org.new(params.get(:org))
          @org = @org_repo.update(@org.id, org_entity)

          flash[:info] = ['Organization has been successfully updated']
          redirect_to routes.orgs_path
        end
      end
    end
  end
end

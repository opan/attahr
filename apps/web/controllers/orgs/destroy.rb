module Web
  module Controllers
    module Orgs
      class Destroy
        include Web::Action
        include Web::Authentication

        before :authenticate!

        params do
          required(:id).filled(:int?)
        end

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(params)
          org = @org_repo.find_by_id_and_member(params.get(:id), current_user.profile.id)
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

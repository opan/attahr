module Web
  module Controllers
    module Orgs
      class Edit
        include Web::Action
        include Web::Authentication

        before :authenticate!

        expose :org

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(params)
          @org = @org_repo.find_through_member(params[:id])
          if @org.nil?
            flash[:errors] = ['Organization not found']
            redirect_to routes.orgs_path, status: 404
          end
        end
      end
    end
  end
end

module Main
  module Controllers
    module Orgs
      class Edit
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :org

        def initialize(org_repo: OrgRepository.new)
          @org_repo ||= org_repo
        end

        def call(params)
          @org = @org_repo.find_by_id_and_member(params.get(:id), current_user.profile.id)
          
          if @org.nil?
            flash[:errors] = ["Cannot find organization with ID [#{params.get(:id)}]"]
            redirect_to Main.routes.orgs_path
          end
        end
      end
    end
  end
end

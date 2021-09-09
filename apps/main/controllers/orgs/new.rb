module Main
  module Controllers
    module Orgs
      class New
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :org

        def initialize(org_repo: OrgRepository.new)
          @org_repo ||= org_repo
        end

        def call(params)
          @org = Org.new
        end
      end
    end
  end
end

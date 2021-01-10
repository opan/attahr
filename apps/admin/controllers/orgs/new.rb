module Admin
  module Controllers
    module Orgs
      class New
        include Admin::Action

        expose :org

        def call(params)
          @org = Org.new
        end
      end
    end
  end
end

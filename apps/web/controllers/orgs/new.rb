module Web
  module Controllers
    module Orgs
      class New
        include Web::Action

        expose :org

        def call(params)
          @org = Org.new
        end
      end
    end
  end
end

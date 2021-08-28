module Main
  module Controllers
    module Products
      class Index
        include Main::Action
        include Main::Authentication

        before :authenticate!

        def call(params)
        end
      end
    end
  end
end

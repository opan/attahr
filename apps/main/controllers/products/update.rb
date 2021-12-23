module Main
  module Controllers
    module Products
      class Update
        include Main::Action

        def call(params)
          self.body = 'OK'
        end
      end
    end
  end
end

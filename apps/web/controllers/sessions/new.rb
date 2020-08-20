module Web
  module Controllers
    module Sessions
      class New
        include Web::Action
        include Web::Authentication

        def call(params)
          if authenticated?
            redirect_to routes.root_path
          end
        end
      end
    end
  end
end

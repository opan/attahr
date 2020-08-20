module Web
  module Controllers
    module Sessions
      class Destroy
        include Web::Action
        include Web::Authentication

        def call(params)
          logout
          redirect_to routes.sign_in_path
        end

        private

        # Disabled csrf verification on sign out flow
        def verify_csrf_token?
          false
        end
      end
    end
  end
end

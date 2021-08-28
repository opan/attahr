module Main
  module Controllers
    module Users
      class SignUp
        include Main::Action
        include Main::Authentication

        expose :user

        def call(params)
          @user = User.new

          if authenticated?
            redirect_to Main.routes.root_path
          end
        end
      end
    end
  end
end

module Admin
  module Controllers
    module Users
      class SignUp
        include Admin::Action
        include Admin::Authentication

        expose :user

        def call(params)
          @user = User.new

          if authenticated?
            redirect_to routes.root_path
          end
        end
      end
    end
  end
end

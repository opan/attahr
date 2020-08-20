module Web
  module Controllers
    module Users
      class SignUp
        include Web::Action
        include Web::Authentication

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

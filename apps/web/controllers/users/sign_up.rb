module Web
  module Controllers
    module Users
      class SignUp
        include Web::Action

        expose :user

        def call(params)
          @user = User.new
        end
      end
    end
  end
end

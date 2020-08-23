module Web
  module Controllers
    module Users
      class Create
        include Web::Action
        include Web::Authentication
        include BCrypt

        before :authenticate!

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:username).filled(:str?)
          end
        end

        expose :user

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
          else
            repo = UserRepository.new
            password_hash = Password.create('defaultPassword')
            user_entity = User.new(email: user_params[:email], username: user_params[:username], password_hash: password_hash)
            @user = repo.create(user_entity)

            flash[:info] = 'User has been successfully created'
            redirect_to routes.users_path
          end
        end

        private

        def user_params
          params[:user]
        end
      end
    end
  end
end

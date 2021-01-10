module Admin
  module Controllers
    module Users
      class Create
        include Admin::Action
        include Main::Authentication
        include BCrypt

        before :authenticate!

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:username).filled(:str?)

            optional(:profile).schema do
              optional(:name).filled(:str?)
              optional(:dob)
            end
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
            user_entity = User.new(
              email: user_params[:email],
              username: user_params[:username],
              password_hash: password_hash,
              profile: user_params[:profile],
            )
            @user = repo.create_with_profile(user_entity)

            flash[:info] = ['User has been successfully created']
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

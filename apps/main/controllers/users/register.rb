module Main
  module Controllers
    module Users
      class Register
        include Main::Action
        include BCrypt

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:username).filled(:str?)
            required(:password).filled(:str?).confirmation
          end
        end

        def initialize(user_repo: UserRepository.new)
          @user_repo ||= user_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = []
            params.errors[:user].each do |k, v|
              flash[:errors] << "#{k.capitalize} #{v}"
            end

            redirect_to Main.routes.sign_up_path and return
          end

          user = @user_repo.find_by_email(user_params[:email])
          unless user.nil?
            flash[:errors] = ['email already exists']
            redirect_to Main.routes.sign_up_path and return
          end

          password = Password.create(user_params[:password])
          user_entity = User.new(
            email: user_params[:email],
            username: user_params[:username],
            password_hash: password,
            profile: { name: user_params[:username] },
          )

          @user_repo.create_with_profile(user_entity)

          flash[:info] = 'User successfully signed up'
          redirect_to Main.routes.root_path
        end

        private

        def user_params
          params[:user]
        end
      end
    end
  end
end

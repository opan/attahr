module Web
  module Controllers
    module Users
      class Register
        include Web::Action
        include BCrypt

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:username).filled(:str?)
            required(:password).filled(:str?).confirmation
          end
        end

        def call(params)
          unless params.valid?
            flash[:errors] = []
            params.errors[:user].each do |k, v|
              flash[:errors] << "#{k.capitalize} #{v}"
            end

            self.status = 422
            redirect_to routes.sign_up_path and return
          end

          repo = UserRepository.new

          user = repo.find_by_email(user_params[:email])
          unless user.nil?
            flash[:errors] = ['email already exists']
            redirect_to routes.sign_up_path and return
          end

          password = Password.create(user_params[:password])
          user_entity = User.new(email: user_params[:email], username: user_params[:username], password_hash: password)
          repo.create(user_entity)
          # if params.valid?
            # repo = UserRepository.new
            # user_entity = User.new(email: user_params[:email], username: user_params[:username])
            # @user = repo.create(user_entity)

            # redirect_to routes.path(:users)
          # else
            # flash[:errors] = params.error_messages
            # self.status = 422
          # end
          #
          flash[:info] = 'User successfully signed up'
          redirect_to routes.root_path
        end

        private

        def user_params
          params[:user]
        end
      end
    end
  end
end

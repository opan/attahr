module Web
  module Controllers
    module Users
      class Create
        include Web::Action

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:username).filled(:str?)
          end
        end

        expose :user

        def call(params)
          if params.valid?
            repo = UserRepository.new
            user_entity = User.new(email: user_params[:email], username: user_params[:username])
            @user = repo.create(user_entity)

            redirect_to routes.path(:users)
          else
            flash[:errors] = params.error_messages
            self.status = 422
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

module Web
  module Controllers
    module Users
      class Update
        include Web::Action
        include Web::Authentication

        before :authenticate!

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:username).filled(:str?)

            optional(:profile).schema do
              optional(:name)
              optional(:date)
            end
          end
        end

        expose :user

        def initialize(repository: UserRepository.new)
          @repository = repository
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            halt 422
          end

          user_entity = User.new(
            email: user_params[:email],
            username: user_params[:username],
            profile: user_params[:profile],
          )

          @user = @repository.find_by_email(user_params[:email])
          if @user.nil?
            flash[:errors] = 'User not found'
            halt 404
          end
          # @user = @repository.update_with_profile(user_entity)

          flash[:info] = 'User has been successfully updated'
          redirect_to routes.users_path
        end

        private

        def user_params
          params[:user]
        end
      end
    end
  end
end

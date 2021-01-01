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

            required(:profile).schema do
              required(:name).filled(:str?)
              optional(:dob).filled(:date?)
            end
          end
        end

        def initialize(user_repo: UserRepository.new, profile_repo: ProfileRepository.new)
          @user_repo = user_repo
          @profile_repo = profile_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            halt 422
          end

          user_entity = User.new(user_params)
          user = @user_repo.find_by_email_with_profile(user_entity.email)
          if user.nil?
            flash[:errors] = ['User not found']
            halt 404
          end

          @user_repo.update(user.id, user_entity)
          @profile_repo.update(user.profile.id, user_entity.profile)

          flash[:info] = ['User has been successfully updated']
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

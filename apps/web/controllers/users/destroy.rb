module Web
  module Controllers
    module Users
      class Destroy
        include Web::Action
        include Web::Authentication

        before :authenticate!

        def initialize(user_repo: UserRepository.new)
          @user_repo = user_repo
        end

        def call(params)
          user = @user_repo.find(params.get(:id))
          if user.nil?
            flash[:errors] = ['User not found']
            redirect_to routes.users_path
          end

          @user_repo.delete(params[:id])

          flash[:info] = [I18n.t('users.success.delete')]
          redirect_to routes.users_path
        end
      end
    end
  end
end

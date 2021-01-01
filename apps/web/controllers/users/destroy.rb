module Web
  module Controllers
    module Users
      class Destroy
        include Web::Action

        def call(params)
          repo = UserRepository.new
          repo.delete(params[:id])

          flash[:info] = [I18n.t('users.success.delete')]
          redirect_to routes.path(:users)
        end
      end
    end
  end
end

module Web
  module Controllers
    module Sessions
      class Create
        include Web::Action

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
          end
        end

        expose :user

        def call(params)
          unless params.valid?
            flash[:errors] = ['Email is invalid']
            redirect_to '/sign_in'
          end

          if authenticate!
            redirect_to routes.users_path
          else
            redirect_to '/sign_in'
          end
        end

        private

        def user_params
          params[:user]
        end

        def warden
          params.env['warden']
        end

        def authenticate!
          warden.authenticate!
        end

        # Disabled csrf verification on sign in flow
        def verify_csrf_token?
          false
        end
      end
    end
  end
end

module Web
  module Controllers
    module Sessions
      class Create
        include Web::Action
        include Web::Authentication

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
          end
        end

        expose :user

        def call(params)
          unless params.valid?
            flash[:errors] = []
            params.errors.each do |e|
              e[:user].each do |k, v|
                flash[:errors] << "#{k.capitalize} #{v}"
              end
            end
            redirect_to routes.sign_in_path and return
          end

          if authenticate!
            redirect_to routes.users_path
          else
            redirect_to routes.sign_in_path
          end
        end

        private

        def user_params
          params[:user]
        end

        # Disabled csrf verification on sign in flow
        def verify_csrf_token?
          false
        end
      end
    end
  end
end

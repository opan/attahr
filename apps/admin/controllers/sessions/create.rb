module Admin
  module Controllers
    module Sessions
      class Create
        include Admin::Action
        include Admin::Authentication

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:password).filled(:str?)
          end
        end

        expose :user

        def call(params)
          unless params.valid?
            flash[:errors] = []
            params.errors[:user].each do |k, v|
              flash[:errors] << "#{k.to_s.capitalize} #{v}"
            end

            redirect_to routes.sign_in_path and return
          end

          authenticate!

          redirect_to routes.root_path
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

module Web
  module Controllers
    module User
      class Create
        include Web::Action

        params do
          required(:email).filled(:str?, format?: /@/)
          required(:username).filled(:str?)
        end

        expose :user

        def call(params)
          if params.valid?
            repo = UserRepository.new
            @user = repo.create(email: params[:email], username: params[:username])
            redirect_to routes.path(:users)
          else
            flash[:errors] = params.error_messages
            self.status = 422
          end
        end
      end
    end
  end
end

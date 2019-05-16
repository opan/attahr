module Web
  module Controllers
    module User
      class Create
        include Web::Action

        params do
          required(:email).filled(:str?, format?: /@/)
          required(:username).filled
        end

        def call(params)
          if params.valid?
            repo = UserRepository.new
            repo.create(email: params[:email], username: params[:username])
            redirect_to routes.path(:users)
          else
            self.status = 422
          end
        end
      end
    end
  end
end

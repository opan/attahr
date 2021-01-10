module Admin
  module Controllers
    module Users
      class Edit
        include Admin::Action
        include Main::Authentication

        before :authenticate!

        expose :user

        def initialize(repository: UserRepository.new)
          @repository = repository
        end

        def call(params)
          user = @repository.find(params[:id])
          if user.nil?
            flash[:errors] = 'User not found'
            halt 404
          end

          @user = @repository.find_by_email_with_profile(user.email)

        end
      end
    end
  end
end

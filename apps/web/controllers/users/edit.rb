module Web
  module Controllers
    module Users
      class Edit
        include Web::Action
        include Web::Authentication

        before :authenticate!

        expose :user
        expose :foo

        def initialize(repository: UserRepository.new)
          @repository = repository
        end

        def call(params)
          # @user = @repository.find(params[:id])
          @user = User.new
          @foo = User.new

          if @user.nil?
            flash[:errors] = 'User not found'
            halt 404
          end
        end
      end
    end
  end
end

module Admin
  module Controllers
    module Users
      class Index
        include Admin::Action

        before :authenticate!

        expose :users

        def initialize(repo = UserRepository.new)
          @repo = repo
        end

        def call(params)
          @users = @repo.all_with_profile
        end
      end
    end
  end
end

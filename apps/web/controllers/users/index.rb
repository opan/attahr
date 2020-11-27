module Web
  module Controllers
    module Users
      class Index
        include Web::Action

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

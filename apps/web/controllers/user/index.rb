module Web
  module Controllers
    module User
      class Index
        include Web::Action

        expose :users

        def initialize(repo = UserRepository.new)
          @repo = repo
        end

        def call(params)
          @users = @repo.all
        end
      end
    end
  end
end

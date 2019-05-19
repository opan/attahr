module Web
  module Controllers
    module User
      class New
        include Web::Action
        
        expose :user

        def initialize(repo)
          @repo = repo
        end

        def call(params)
          @user = @repo
        end
      end
    end
  end
end

module Web
  module Controllers
    module Users
      class New
        include Web::Action
        
        expose :user

        def initialize(entity = User.new)
          @entity = entity
        end

        def call(params)
          @user = @entity
        end
      end
    end
  end
end

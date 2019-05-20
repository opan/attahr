module Web
  module Controllers
    module User
      class New
        include Web::Action
        
        expose :user

        def initialize(entity)
          @entity = entity
        end

        def call(params)
          @user = @entity
        end
      end
    end
  end
end

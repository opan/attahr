module Admin
  module Controllers
    module Users
      class New
        include Admin::Action

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

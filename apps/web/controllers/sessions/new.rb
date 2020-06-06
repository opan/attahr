module Web
  module Controllers
    module Sessions
      class New
        include Web::Action

        expose :user

        def call(params)
          @user = User.new
        end
      end
    end
  end
end

module Admin
  module Controllers
    module Sessions
      class New
        include Admin::Action
        include Admin::Authentication

        def call(params)
          flash[:errors] = [warden.message] unless warden.message.nil?

          if authenticated?
            redirect_to routes.root_path
          end
        end
      end
    end
  end
end

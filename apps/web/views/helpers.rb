module Web
  module Views
    module Helpers
      def sign_out_link
        unless current_user.nil?
          form_for :session, routes.sign_out_path, method: :delete do
            submit 'Sign Out', class: 'ui button'
          end
        end
      end
    end
  end
end

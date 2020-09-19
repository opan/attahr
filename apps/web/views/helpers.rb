module Web
  module Views
    module Helpers
      def sign_out_link
        unless current_user.nil?
          form_for :session, routes.sign_out_path, method: :delete do
            submit 'Sign Out', class: 'mr-4 lg:inline-block text-sm px-4 py-2 leading-none border rounded text-blue-300 border-blue-300 hover:border-transparent hover:text-blue-500 hover:bg-white mt-4 lg:mt-0'
          end
        end
      end
    end
  end
end

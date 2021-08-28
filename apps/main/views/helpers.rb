module Main
  module Views
    module Helpers
      def sign_out_link
        binding.pry
        unless current_user.nil?
          form_for :session, Main.routes.sign_out_path, method: :delete do
            submit 'Sign Out', class: 'mr-4 lg:inline-block text-sm px-4 py-2 leading-none border font-bold rounded text-blue-500 border-blue-500 hover:border-blue-500 hover:text-white hover:bg-blue-500 mt-4 lg:mt-0'
          end
        end
      end
    end
  end
end

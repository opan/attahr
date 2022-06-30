# frozen_string_literal: true
module Main
  module Controllers
    module PointOfSales
      class UpdateQty
        include Main::Action
        include Main::Authentication

        accept :json

        before :authenticate!

        def initialize()
          
        end

        def call(params)
          
        end

        private

        def error_messages(msg = [])
          JSON.generate({ errors: msg })
        end

        def verify_csrf_token?
          false
        end
      end
    end
  end
end

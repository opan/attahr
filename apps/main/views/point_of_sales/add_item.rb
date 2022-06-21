# frozen_string_literal: true

module Main
  module Views
    module PointOfSales
      class AddItem
        include Main::View

        layout false

        format :json

        def render
          JSON.generate({ product_id: params[:product_id] })
        end
      end
    end
  end
end

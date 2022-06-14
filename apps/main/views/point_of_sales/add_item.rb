module Main
  module Views
    module PointOfSales
      class AddItem
        include Main::View
        format :json

        def render
          binding.pry
          raw JSON.generate({product_id: params[:product_id]})
        end
      end
    end
  end
end

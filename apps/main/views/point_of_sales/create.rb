module Main
  module Views
    module PointOfSales
      class Create
        include Main::View
        template 'point_of_sales/new'
        layout :user
      end
    end
  end
end

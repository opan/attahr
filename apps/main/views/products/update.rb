module Main
  module Views
    module Products
      class Update
        include Main::View
        template 'products/edit'
      end
    end
  end
end

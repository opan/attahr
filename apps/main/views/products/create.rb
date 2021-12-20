module Main
  module Views
    module Products
      class Create
        include Main::View
        template 'products/new'
      end
    end
  end
end

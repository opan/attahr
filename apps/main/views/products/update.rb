module Main
  module Views
    module Products
      class Update
        include Main::View
        template 'products/edit'
        layout :user
      end
    end
  end
end

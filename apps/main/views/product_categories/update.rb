module Main
  module Views
    module ProductCategories
      class Update
        include Main::View
        template 'product_categories/edit'
        layout :user
      end
    end
  end
end

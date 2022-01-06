module Main
  module Views
    module ProductCategories
      class Create
        include Main::View
        template 'product_categories/new'
        layout :user
      end
    end
  end
end

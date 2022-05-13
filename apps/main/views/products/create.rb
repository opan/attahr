# frozen_string_literal: true

module Main
  module Views
    module Products
      class Create
        include Main::View
        template 'products/new'
        layout :user
      end
    end
  end
end

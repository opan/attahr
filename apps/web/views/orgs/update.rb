module Web
  module Views
    module Orgs
      class Update
        include Web::View
        layout :admin
        template 'orgs/edit'
      end
    end
  end
end

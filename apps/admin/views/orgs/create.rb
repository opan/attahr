module Admin
  module Views
    module Orgs
      class Create
        include Admin::View
        layout :admin
        template 'orgs/new'
      end
    end
  end
end

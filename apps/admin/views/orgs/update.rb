module Admin
  module Views
    module Orgs
      class Update
        include Admin::View
        layout :admin
        template 'orgs/edit'
      end
    end
  end
end

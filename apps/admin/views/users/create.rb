module Admin
  module Views
    module Users
      class Create
        include Admin::View
        layout :admin
        template 'users/new'
      end
    end
  end
end

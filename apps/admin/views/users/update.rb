module Admin
  module Views
    module Users
      class Update
        include Admin::View
        layout :admin
        template 'users/edit'
      end
    end
  end
end

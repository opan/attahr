module Web
  module Views
    module Users
      class Update
        include Web::View
        layout :admin
        template 'users/edit'
      end
    end
  end
end

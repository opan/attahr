module Web
  module Views
    module Users
      class Create
        include Web::View
        layout :admin
        template 'users/new'
      end
    end
  end
end

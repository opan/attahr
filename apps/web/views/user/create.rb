module Web
  module Views
    module User
      class Create
        include Web::View

        template 'user/new'
      end
    end
  end
end

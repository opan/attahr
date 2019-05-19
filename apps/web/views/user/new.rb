module Web
  module Views
    module User
      class New
        include Web::View

        def form
          form_for :user, routes.users_path, class: 'ui form' do
            div class: 'field' do
              label :username
              text_field :username
            end

            div class: 'field' do
              label :email
              text_field :email
            end

            submit 'Create', class: 'ui button'
          end
        end
      end
    end
  end
end

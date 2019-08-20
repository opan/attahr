require 'features_helper'

RSpec.describe 'Delete user' do
  let(:repository) { UserRepository.new }

  before(:each) do
    @user = repository.create(username: 'user-delete', email: 'user-delete@mail.com')
  end

  it 'delete existing user' do
    visit '/users'
    expect(page).to have_content 'user-delete@mail.com'

    click_button "#{@user.id}-delete-user"
    expect(page).not_to have_content 'user-delete@mail.com'

    expect(page).to have_current_path '/users'
    expect(page).to have_content I18n.t('users.success.delete')
  end
end

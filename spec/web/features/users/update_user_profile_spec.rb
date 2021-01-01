require 'features_helper'

RSpec.describe 'Update user profile' do
  let(:repository) { UserRepository.new }
  let(:user) {
    repository.create_with_profile(User.new(
      email: 'foo@email.com',
      username: 'foo',
      password_hash:  BCrypt::Password.create('defaultPassword'),
      profile: { name: 'foo bar' },
    ))
  }

  it 'update user profile change name' do
    login(user: user, password_supply: 'defaultPassword')

    visit '/users'
    expect(page).to have_content 'foo@email.com'
    expect(page).to have_current_path '/users'

    click_link "#{user.id}-edit-user"
    expect(page).to have_current_path "/users/#{user.id}/edit"

    fill_in 'user[profile][name]', with: 'foo bar update'
    fill_in 'user[profile][dob]', with: '20/01/2020'
    click_button 'Update'

    expect(page).to have_current_path '/users'
    expect(page).to have_content '2020-01-20'
    expect(page).to have_content 'foo bar update'
  end
end

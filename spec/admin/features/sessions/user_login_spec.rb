require 'features_helper'

RSpec.describe 'User login', type: :feature do
  let(:repository) { UserRepository.new }
  let(:email) { 'foo@mail.com' }
  let(:username) { 'foo' }
  let(:password) { 'defaultPassword' }
  let(:user) do
    user = User.new(email: email, username: username, password_hash: BCrypt::Password.create(password), profile: { name: username })
    repository.create_with_profile(user)
  end

  it 'login with valid account' do
    visit Admin.routes.sign_in_path

    expect(page).to have_content('Sign In')

    fill_in name: 'user[email]', with: user.email
    fill_in name: 'user[password]', with: password
    click_button 'Sign In'

    expect(page.current_path).to eq Admin.routes.root_path + '/'
  end

  it 'login with invalid account' do
    visit Admin.routes.sign_in_path

    expect(page).to have_content('Sign In')

    fill_in name: 'user[email]', with: email
    fill_in name: 'user[password]', with: '123'
    click_button 'Sign In'

    expect(page).to have_content %(email or password is incorrect)
  end
end

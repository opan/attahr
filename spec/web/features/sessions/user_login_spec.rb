require 'features_helper'

RSpec.describe 'User login', type: :feature do
  let(:repository) { UserRepository.new }
  let(:email) { 'foo@mail.com' }
  let(:username) { 'foo' }
  let(:password) { 'defaultPassword' }
  let(:user) do
    user = User.new(email: email, username: username, password_hash: BCrypt::Password.create(password))
    repository.create(user)
  end

  it 'login with valid account' do
    visit '/sign_in'

    expect(page).to have_content('Sign In')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Sign In'

    expect(page.current_path).to eq '/'
  end

  it 'login with invalid account' do
    visit '/sign_in'

    expect(page).to have_content('Sign In')

    fill_in 'Email', with: email
    fill_in 'Password', with: '123'
    click_button 'Sign In'

    expect(page).to have_content %(email or password is incorrect)
  end
end

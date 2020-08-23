module HelperMethods
  def signed_user_entity(email: 'foo@mail.com', username: 'foo', password: '123')
    User.new(email: email, username: username, password_hash: BCrypt::Password.create(password))
  end

  def login(user: UserRepository.new.create(signed_user_entity))
    visit '/sign_in'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123'
    click_button 'Sign In'
  end
end

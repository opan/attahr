module HelperMethods
  def signed_user_entity(email: 'foo@mail.com', username: 'foo', password: '123')
    User.new(
      email: email,
      username: username,
      password_hash: BCrypt::Password.create(password),
      profile: { name: username }
    )
  end

  def login(user: UserRepository.new.create_with_profile(signed_user_entity), password_supply: nil)
    visit '/sign_in'

    fill_in name: 'user[email]', with: user.email
    fill_in name: 'user[password]', with: password_supply||'123'
    click_button 'Sign In'
  end
end

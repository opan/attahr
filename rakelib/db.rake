namespace :db do
  desc 'Seeds database (only for development)'
  task seeds: :environment do
    user_repo = UserRepository.new
    puts 'opan'
    password = BCrypt::Password.create('defaultPassword')
    user_repo.create_with_profile(User.new(
      email: 'foo@mail.com',
      username: 'foo',
      password_hash: password,
      profile: Profile.new(name: 'foo')
    ))
  end
end

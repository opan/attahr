WardenMock = Struct.new(:authenticate, :authenticate!, :authenticated?, :user)
WardenDouble = WardenMock.new(
  true,
  true,
  true,
  User.new(
    id: 999,
    email: 'default@mail.com',
    username: 'default',
    password_hash: BCrypt::Password.create('foo-bar'),
    profile: Profile.new(id: 1000)
  )
)
RSpec.configure do |config|
  config.before(:each) do
    @warden = WardenDouble
  end
end

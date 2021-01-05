WardenMock = Struct.new(:authenticate, :authenticate!, :authenticated?, :user)
WardenDouble = WardenMock.new(true, true, true, User.new(id: 999, email: 'default@mail.com', username: 'default', profile: Profile.new(id: 1000)))
RSpec.configure do |config|
  config.before(:each) do
    @warden = WardenDouble
    # @warden = double('Warden', authenticate: true, authenticate!: true, authenticated?: true, user: )
  end
end

RSpec.configure do |config|
  config.before(:each) do
    @warden = double('Warden', authenticate: true, authenticate!: true, authenticated?: true, user: User.new(id: 999, email: 'default@mail.com', username: 'default'))
  end
end

RSpec.configure do |config|
  config.before(:each) do
    @warden = double("Warden", authenticate: true, authenticate!: true)
  end
end


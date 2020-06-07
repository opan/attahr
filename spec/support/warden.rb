RSpec.configure do |config|
  config.before(:each) do
    @warden = double("Warden", authenticate: true)
  end
end


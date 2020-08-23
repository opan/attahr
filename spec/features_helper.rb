# Require this file for feature tests
require_relative './spec_helper'

require 'capybara'
require 'capybara/rspec'
require 'warden'

RSpec.configure do |config|
  config.include RSpec::FeatureExampleGroup
  config.include Warden::Test::Helpers, type: :feature

  config.include Capybara::DSL,           feature: true
  config.include Capybara::RSpecMatchers, feature: true
  config.after(:each, type: :feature) do
    Warden.test_reset!
  end

  config.include HelperMethods, type: :feature
end

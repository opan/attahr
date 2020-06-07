source 'https://rubygems.org'

gem 'rake'
gem 'hanami',       '~> 1.3'
gem 'hanami-model', '~> 1.3'

gem 'pg'
gem 'i18n'
gem 'nokogiri', '>= 1.10.8'
gem 'rack', '>= 2.0.8'
gem 'json', '>= 2.0.0'
gem 'warden'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  # gem 'shotgun', platforms: :ruby
  gem 'hanami-webconsole'
end

group :plugins do
  gem 'hanami-reloader', "~> 0.3"
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
  gem 'pry', '~> 0.12.2'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'database_cleaner'
end

group :production do
  # gem 'puma'
end

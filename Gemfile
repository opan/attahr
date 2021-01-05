source 'https://rubygems.org'

gem 'rake'
gem 'hanami',       '~> 1.3'
gem 'hanami-model', '~> 1.3'

gem 'pg'
gem 'i18n'
gem "nokogiri", ">= 1.11.0.rc4"
gem 'rack', '>= 2.0.8'
gem 'json', '>= 2.0.0'
gem 'warden'
gem 'bcrypt'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun', platforms: :ruby
  gem 'hanami-webconsole'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'guard'
end

group :plugins do
  # gem 'hanami-reloader', "~> 0.3"
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
  gem 'pry', '~> 0.12.2'
  # gem 'guard-rack'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'rspec-hanami'
  gem 'rom-factory'
end

group :production do
  # gem 'puma'
end

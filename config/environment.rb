require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require 'warden'
require 'bcrypt'
require_relative '../lib/atthar'
require_relative '../apps/admin/application'
require_relative '../apps/main/application'

Hanami.configure do
  middleware.use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = ->(env) do
      FailureApp.new.call(env)
    end
  end

  # When mounting application, the one that mounted to '/'
  # should be put the latest. Otherwise the rest of application that get mounted can't be accessed
  mount Admin::Application, at: '/admin'
  mount Main::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/atthar_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/atthar_development'
    #    adapter :sql, 'mysql://localhost/atthar_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/atthar/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    mailer do
      delivery :smtp, address: ENV.fetch('SMTP_HOST'), port: ENV.fetch('SMTP_PORT')
    end
  end
end

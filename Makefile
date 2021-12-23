.PHONY: all

test.db.prepare:
	HANAMI_ENV=test bundle exec hanami db prepare

db.seeds:
	bundle exec rake db:seeds

db.prepare:
	HANAMI_ENV=development bundle exec hanami db prepare
	bundle exec rake db:seeds

rspec:
	bundle exec rspec spec

rspec.feature:
	bundle exec rspec spec/{admin,main}/features/**/*_spec.rb

rspec.unit:
	bundle exec rspec --exclude-pattern "spec/{admin,main}/features/**/*_spec.rb"

guard:
	bundle exec guard

server:
	bundle exec hanami server

console:
	bundle exec hanami console

routes:
	bundle exec hanami routes

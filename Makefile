.PHONY: all

test.db.prepare:
	HANAMI_ENV=test hanami db prepare

db.prepare:
	HANAMI_ENV=development hanami db prepare
	bundle exec rake db:seeds

rspec:
	bundle exec rspec spec

rspec.feature:
	bundle exec rspec spec/{admin,main}/features/**/*_spec.rb

rspec.unit:
	bundle exec rspec --exclude-pattern "spec/{admin,main}/features/**/*_spec.rb"

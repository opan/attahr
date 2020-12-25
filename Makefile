.PHONY: all

test.db.prepare:
	HANAMI_ENV=test hanami db prepare

db.prepare:
	HANAMI_ENV=development hanami db prepare

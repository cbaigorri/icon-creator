TESTS = test/*.coffee
REPORTER = spec

test:
			./node_modules/.bin/mocha \
				--compilers coffee:coffee-script \
				--ui bdd \
				--require should \
				--reporter $(REPORTER) \
				--timeout 2000 \
				--growl \
				$(TESTS)

.PHONY: test
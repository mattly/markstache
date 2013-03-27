REPORTER ?= dot

test: test-unit

test-unit:
	@NODE_ENV=test \
	  ./node_modules/.bin/mocha \
	  --compilers coffee:coffee-script \
	  --reporter $(REPORTER)

package.json:
	coffee package.coffee > package.json

markstache.js:
	coffee -c markstache.coffee

build: clean package.json markstache.js

clean:
	rm -f markstache.js
	rm -f package.json

.PHONY: test test-unit clean

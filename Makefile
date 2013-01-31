REPORTER ?= dot

test: test-unit

test-unit:
	@NODE_ENV=test \
	  ./node_modules/.bin/mocha \
	  --reporter $(REPORTER)

package.json:
	coffee package.coffee > package.json

clean:
	rm -f markstache.js
	rm -f package.json

.PHONY: test test-unit clean

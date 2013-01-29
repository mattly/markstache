REPORTER = dot

test: test-unit

test-unit:
	@NODE_ENV=test \
	  ./node_modules/.bin/mocha \
	  --reporter= $(REPORTER)

package.json:
	coffee package.coffee > package.json

clean:
	rm markstache.js
	rm package.json

.PHONY: test test-unit clean

assert = require('chai').assert
fs = require('fs')

source = fs.readFileSync('test/fixtures/markstache.md', 'utf8')

markstache = require('../markstache')

describe 'extractFrontMatter', ->
  describe "with front matter", ->
    [frontMatter, text] = markstache.extractFrontMatter(source)
    lines = text.split("\n")

    it "provides a dict as frontMatter", ->
      assert.isObject(frontMatter)
      assert.propertyVal(frontMatter, 'author', 'Matthew Lyon')

    it "removes front matter from the text", ->
      assert.equal(lines[0], '')
      assert.equal(lines[1], '# {{ title }}')

  describe "without front matter", ->
    plain = "# Documents\n\nHello There."
    [frontMatter, text] = markstache.extractFrontMatter(plain)

    it "provides an empty dict as front matter", ->
      assert.isObject(frontMatter)
      assert.equal(Object.keys(frontMatter), 0)

    it "returns the source text as text", ->
      assert.equal(text, plain)

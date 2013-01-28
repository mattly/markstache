assert = require('chai').assert
fs = require('fs')

markstache = require('../markstache')
together = require('./together')

sourceText = undefined
sample = 'test/fixtures/markstache.md'

before together()
  .setter('data', fs.readFile, sample, 'utf8')
  .do(-> sourceText = @get('data'))

describe 'lexing', ->
  tree = undefined
  lex = (cb) -> markstache.lexer(sourceText, cb)
  sections = [
    { type:'text', text: /title/ }
    { type:'image', size:'500x300', align:'right', text:/\*\*Pork/
    source:'IMG2709.jpg', title:'Mmmm...' }
    { type:'text', text: [/favorite/, /MLT/] }
    { type:'blockquote', author: 'Miracle {{ miracleWorker }}',
    text: /tomato is ripe./ }
  ]

  checkProperty = (obj, prop, expected) ->
    assert.property(obj, prop)
    if expected instanceof Array
      checkProperty(obj, prop, expectation) for expectation in expected
    else if expected instanceof RegExp
      assert.match(obj[prop], expected)
    else assert.propertyVal(obj, prop, expected)

  beforeEach together()
    .setter('tree', lex)
    .do(-> tree = @get('tree'))

  it 'extracts frontmatter metadata', ->
    assert(tree.metadata)
    assert.equal(tree.metadata.author, 'Matthew Lyon')

  it 'extracts markdown references', ->
    assert(tree.references)
    assert.equal(tree.references.pbride?.href, 'page:princessbride')

  it 'extracts inline components', ->
    assert.instanceOf(tree, Array)
    for section, idx in sections
      assert.ok(tree[idx])
      checkProperty(tree[idx], key, value) for key, value of section


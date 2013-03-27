assert = require('chai').assert
fs = require('fs')

markstache = require('../markstache')
together = require('./together')

sourceText = undefined
sample = 'test/fixtures/markstache.md'

before together()
  .do(-> fs.readFile(sample, 'utf8', @setter('data')))
  .do(-> sourceText = @get('data'))

describe 'lexing', ->
  tree = undefined
  sections = [
    { type:'text', tokens: [{type:'heading', depth: 1, text: /title/ }]}
    { type:'image', size:'500x300', align:'right', source:'IMG2709.jpg',
    title:'Mmmm...', tokens:[{type:'paragraph', text:/\*\*Pork/}] }
    { type:'text', tokens: [
      {type:'paragraph', text:/favorite/}, {type:'paragraph', text:/MLT/}] }
    { type:'blockquote', author: 'Miracle {{ miracleWorker }}', tokens: [
      {type:'paragraph', text:/tomato is ripe./}]}
  ]

  checkProperty = (obj, prop, expected) ->
    assert.property(obj, prop)
    if expected instanceof Array
      checkProperty(obj, prop, expectation) for expectation in expected
    else if expected instanceof RegExp
      assert.match(obj[prop], expected)
    else assert.propertyVal(obj, prop, expected)

  beforeEach together()
    .do(-> markstache.lexer(sourceText, @setter('tree')))
    .do(-> tree = @get('tree'))

  it 'extracts frontmatter metadata', ->
    assert(tree.metadata)
    assert.equal(tree.metadata.author, 'Matthew Lyon')

  it 'extracts markdown references', ->
    assert(tree.references)
    assert.equal(tree.references.pbride?.href, 'page:princessbride')

  it 'stores raw template text', ->
    for section in tree
      assert(section.rawText)

  it 'extracts inline components', ->
    assert.instanceOf(tree, Array)
    for section, idx in sections
      assert.ok(tree[idx])
      for key, value of section when key isnt 'tokens'
        checkProperty(tree[idx], key, value)
      assert.property(tree[idx], 'tokens')
      tokenIdx = -1
      for token in section.tokens
        tokenIdx += 1
        while token.type isnt tree[idx].tokens[tokenIdx].type
          tokenIdx += 1
          if not tree[idx].tokens[tokenIdx]
            assert.ok(false, "count not find next #{token.type} token")
            break
        for key, value of token when key isnt 'type'
          checkProperty(tree[idx].tokens[tokenIdx], key, value)


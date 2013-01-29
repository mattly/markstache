assert = require('chai').assert
domify = require('cheerio').load

markstache = require('../markstache')
source = require('fs').readFileSync('test/fixtures/markstache.md', 'utf8')

describe 'rendering', ->
  describe 'default/missing component types', ->
    textComponent =
      type: 'text'
      tokens: [{ type: 'paragraph', text: '{{ prefix }} make me a [sandwich][]' }]
    tree = [textComponent]
    tree.references = { sandwich: { href:'sammichlink', title:'sammichtitle' } }
    context = { prefix: 'sudo' }
    output = null
    html = null

    beforeEach (done) ->
      markstache.parser tree, null, (err, text) ->
        if err then return done9err
        output = text
        html = domify(text)
        done()

    it 'renders references into text markdown', ->
      link = html('a')
      assert.equal(link.text(), 'sandwich')
      assert.equal(link.attr('href'), 'sammichlink')
      assert.equal(link.attr('title'), 'sammichtitle')

    it 'renders context variables into text mustache'
    it 'does not render context variables as markdown'
    it 'renders markdown references into context for mustache'

  describe 'component sections', ->
    it 'provides the component type'
    it 'extracts frontmatter to dict'
    it 'renders context variables into frontmatter values'
    it 'renders markdown in frontmatter values'
    it 'provides references to frontmatter values'
    it 'extracts content to text key of dict'
    it 'renders context variables into text'
    it 'renders markdown in text'
    it 'provides references to text'


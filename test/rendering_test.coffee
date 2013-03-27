assert = require('chai').assert
domify = require('cheerio').load

markstache = require('../markstache')
source = require('fs').readFileSync('test/fixtures/markstache.md', 'utf8')

describe 'rendering HTML', ->
  describe 'default/missing component types', ->
    context = { prefix: '_sudo_' }
    references =
      sandwich: { href: 'link', title: 'title' }
      bacon: { href: '', title: 'bacon' }
    output = null
    html = null

    beforeEach (done) ->
      textComponent =
        type: 'text'
        tokens: [{ type: 'paragraph', text:
          '{{ prefix }} make me a {{ $refs.bacon.title }}[sandwich][]'
        }]
      tree = [textComponent]
      tree.references = references
      markstache.renderHTML tree, context, (err, text) ->
        if err then return done(err)
        output = text
        html = domify(text)
        done()

    it 'renders references into text markdown', ->
      link = html('a')
      assert.equal(link.text(), 'sandwich')
      assert.equal(link.attr('href'), 'link')
      assert.equal(link.attr('title'), 'title')

    it 'renders context variables into text mustache pre-markdown', ->
      assert.match(html('p').text(), /^_sudo_ make/)

    it 'renders markdown references into context for mustache', ->
      assert.match(html('p').text(), /bacon/)

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


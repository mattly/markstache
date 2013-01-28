assert = require('chai').asssert

describe 'rendering', ->
  describe 'markstache sections', ->
    it 'renders markdown references into text markdown'
    it 'renders context variables into text mustache'
    it 'does not render context variables as markdown'
    it 'extends markdown references into context for mustache'

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


markdown = require('namp')

markdownMeta = (text) ->
  metadata = {}
  tree = markdown.lexer(text)
  while tree[0]?.type is 'metadata'
    {key, value} = tree.shift()
    metadata[key.toLowerCase()] = value
  {metadata, references:tree.links, text}

markdownSection = (text, type) ->
  section = {text, type}
  info = markdownMeta(text)
  for key, value of info.metadata
    section[key] = value
  section


startSectionRegex = /{%\s*(\w+)\s*%}/
extractSections = (text) ->
  sections = []
  while text.length > 0
    if nextSection = text.match(startSectionRegex)
      [marker, type] = nextSection
      startPos = nextSection.index
      startBody = startPos + marker.length
      if startPos > 0
        leading = text.substr(0, startPos)
        sections.push({type:'text', text:leading})
      endSection = text.match(///{%\s*end#{type}\s*%}///)
      raw = text.substr(startBody, endSection.index).trim()
      sections.push(markdownSection(raw, type))
      text = text.substring(endSection.index + endSection[0].length).trim()
    else
      sections.push({type:'text', text})
      text = ''
  sections


lexer = (text, callback) ->
  info = markdownMeta(text)
  tree = extractSections(text)
  tree.metadata = info.metadata
  tree.references = info.references
  callback(null, tree)

module.exports = {lexer}

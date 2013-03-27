markdown = require('marked')
mustache = require('mustache')

frontMatterLine = /^(\w+):\s*(.*)$/m

extractFrontMatter = (text) ->
  if text.match(frontMatterLine)
    frontMatter = {}
    [front, rest...] = text.split("\n\n")
    lines = front.split('\n')
    while match = lines[0]?.match(frontMatterLine)
      [line, key, value] = match
      frontMatter[key.toLowerCase()] = value
      lines.shift()
    [frontMatter, rest.join("\n\n")]
  else [{}, text]

markdownSection = (text, type) ->
  [section, text] = extractFrontMatter(text)
  section.type = type
  section.tokens = markdown.lexer(text)
  section.rawText = text
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
        sections.push(markdownSection(leading, 'text'))
      endSection = text.match(///{%\s*end#{type}\s*%}///)
      raw = text.substr(startBody, endSection.index).trim()
      sections.push(markdownSection(raw, type))
      text = text.substring(endSection.index + endSection[0].length).trim()
    else
      sections.push(markdownSection(leading, 'text'))
      text = ''
  sections


lexer = (text, callback) ->
  [info, text] = extractFrontMatter(text)
  list = extractSections(text)
  list.metadata = info
  list.references = {}
  for section in list
    for name, link of section.tokens.links
      list.references[name] = link
  callback(null, list)

parser = (tree, context, callback) ->
  output = []
  context.$refs = tree.references
  for section in tree
    section.tokens.links = tree.references
    mdOut = markdown.parser(section.tokens)
    muOut = mustache.render(mdOut, context)
    output.push(muOut)
  callback(null, output.join('\n'))

module.exports = {
  extractFrontMatter
  lexer
  parser
}

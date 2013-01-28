markdown = require('marked')

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
    [frontMatter, rest.join('\n\n')]
  else [{}, text]

markdownSection = (text, type) ->
  [section, text] = extractFrontMatter(text)
  section.type = type
  section.text = text
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
  [info, text] = extractFrontMatter(text)
  list = extractSections(text)
  list.metadata = info
  list.references = markdown.lexer(text).links
  callback(null, list)

module.exports = {extractFrontMatter, lexer}

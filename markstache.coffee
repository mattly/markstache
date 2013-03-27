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
      sections.push(markdownSection(text, 'text'))
      text = ''
  sections


lexer = (text, callback) ->
  try
    [info, body] = extractFrontMatter(text)
    list = extractSections(body)
  catch e
    return callback(e)
  list.metadata = info
  list.references = {}
  for section in list
    for name, link of section.tokens.links
      list.references[name] = link
  callback(null, list)

render = (format, tree, context, callback) ->
  context.$refs = tree.references
  sections = (section for section in tree)
  output = []
  next = ->
    if section = sections.pop()
      renderers[section.type](section, context, format, chain)
    else
      out = mustache.render(output.join('\n'), context)
      callback(null, out)
  chain = (err, result) ->
    if err then return cb(err)
    output.push(result)
    next()
  next()

curryL = (argsL..., fn) ->
  (argsR...) ->
    fn.apply(undefined, argsL.concat(argsR))

renderHTML = curryL('html', render)
renderText = curryL('text', render)

renderers =
  text: (tree, context, format, cb) ->
    if cb is undefined and format instanceof 'function'
      cb = format
      format = 'text'
    switch format
      when 'html'
        tree.tokens.links = context.$refs
        cb(null, markdown.parser(tree.tokens))
      else cb(null, tree.rawText)

module.exports = {
  extractFrontMatter
  lexer
  renderHTML
  renderText
  renderers
}

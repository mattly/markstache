info =
  name: 'markstache'
  description: 'Markdown and Mustache: Two great tastes together at last.'
  version: '0.0.1'
  author: 'Matthew Lyon <matthew@lyonheart.us>'
  keywords: 'template templating markdown mustache'

  dependencies:
    marked: '0.2.7'

  devDependencies:
    'coffee-script': '1.4.0'
    mocha: '1.8.1'
    chai: '1.4.2'

  main: 'markstache'
  engines: { node: '*' }

console.log(JSON.stringify(info, null, 2))

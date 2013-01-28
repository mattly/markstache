github = 'github.com/mattly/markstache'
info =
  name: 'markstache'
  description: 'Markdown and Mustache: Two great tastes together at last.'
  version: '0.0.2'
  author: 'Matthew Lyon <matthew@lyonheart.us>'
  keywords: 'template templating markdown mustache'.split(' ')
  tags: 'template templating markdown mustache'.split(' ')
  homepage: "https://#{github}"
  repository: "git://#{github}.git"
  bugs: "https://#{github}/issues"

  dependencies:
    marked: '0.2.7'

  devDependencies:
    'coffee-script': '1.4.0'
    mocha: '1.8.1'
    chai: '1.4.2'

  main: 'markstache'
  engines: { node: '*' }

console.log(JSON.stringify(info, null, 2))

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
    # markdown parser
    marked: '0.2.7'
    # mustache renderer
    mustache: '0.7.2'

  devDependencies:
    'coffee-script': '1.4.0'
    # test runner / framework
    mocha: '1.8.1'
    # assertions helper
    chai: '1.4.2'
    # dom parsing
    cheerio: '0.10.5'

  scripts:
    # preinstall
    # postinstall
    # poststart
    # prepublish
    # pretest
    test: "make test"

  main: 'markstache'
  engines: { node: '*' }

console.log(JSON.stringify(info, null, 2))

# Markstache

by Matthew Lyon <matthew@lyonheart.us>

Markdown and Mustache: two great tastes, together at last.

Markstache is a template rendering system with a few goals:

1. Write text in Markdown.
2. Insert variables from the rendering context into the output with Mustache.
3. Make metadata from the "Front Matter" available to the rendering context.
4. Make references from the Markdown document available to the rendering
   context, to gather information about links or use wiki-style references.
5. Provide a higher-level component system for creating specialized markup
   components, such as image galleries or such.

## Dependencies

- [marked](https://github.com/chjj/marked): Markdown Rendering. It's fast,
  maintained, and the maintainer seems responsive.
- [mustache](https://github.com/janl/mustache.js): Mustache Rendering.

## Developer Dependencies

- CoffeeScript: What all the code is written in. Deal with it.
- Mocha: Test Framework
- Chai: Assertion Helpers

## License

See LICENSE

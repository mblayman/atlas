local Parser = require 'atlas.templates.parser'

describe('Parser', function()
  it('constructs an instance', function()
    local parser = Parser()

    assert.equal(getmetatable(parser), Parser)
  end)

  it('parses to an AST', function()
    local parser = Parser()
    local source = 'hello template'

    local ast = parser:parse(source)

    assert.same(ast, {source})
  end)
end)

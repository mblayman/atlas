local Parser = require 'atlas.templates.parser'

describe('Parser', function()
  it('constructs an instance', function()
    local parser = Parser()

    assert.equal(Parser, getmetatable(parser))
  end)

  it('parses to an AST', function()
    local parser = Parser()
    local source = 'hello template'

    local ast = parser:parse(source)

    -- TODO: produce an AST node with the source
    assert.same({{node_type = 'text', text = ''}}, ast)
  end)
end)

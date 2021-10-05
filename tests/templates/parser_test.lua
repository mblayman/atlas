local Parser = require 'atlas.templates.parser'

describe('Parser', function()
  it('constructs an instance', function()
    local parser = Parser()

    assert.equal(Parser, getmetatable(parser))
  end)

  it('parses raw text to an AST', function()
    local parser = Parser()
    local source = 'hello template'

    local ast = parser:parse(source)

    assert.same({{node_type = 'text', text = 'hello template'}}, ast)
  end)

  it('parses an expression to an AST', function()
    local parser = Parser()
    local source = 'before {{ variable }} after'
    -- local source = '{{ variable }} after'

    local ast = parser:parse(source)

    local expected = {
      {node_type = 'text', text = 'before '},
      {node_type = 'expression', expression = 'variable '},
      {node_type = 'text', text = ' after'},
    }
    assert.same(expected, ast)
  end)
end)

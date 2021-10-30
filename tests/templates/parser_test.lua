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

  it('parses an expression to an AST #xfail', function()
    local parser = Parser()
    local source = 'before {{ variable }} after'

    local ast = parser:parse(source)

    local expected = {
      {node_type = 'text', text = 'before '},
      {node_type = 'expression', expression = 'variable '},
      {node_type = 'text', text = ' after'},
    }
    assert.same(expected, ast)
  end)

  it('parses an expression single quoted literal to an AST', function()
    local parser = Parser()
    local source = "before {{ 'hello' }} after"

    local ast = parser:parse(source)

    local expected = {
      {node_type = 'text', text = 'before '},
      {node_type = 'text', text = 'hello'},
      {node_type = 'text', text = ' after'},
    }
    assert.same(expected, ast)
  end)

  it('parses an expression double quoted literal to an AST', function()
    local parser = Parser()
    local source = 'before {{ "hello" }} after'

    local ast = parser:parse(source)

    local expected = {
      {node_type = 'text', text = 'before '},
      {node_type = 'text', text = 'hello'},
      {node_type = 'text', text = ' after'},
    }
    assert.same(expected, ast)
  end)

  it('parses an expression literal with newline to an AST', function()
    local parser = Parser()
    local source = [[before {{ "hello
world" }} after]]

    local ast = parser:parse(source)

    local expected = {
      {node_type = 'text', text = 'before '},
      {node_type = 'text', text = 'hello\nworld'},
      {node_type = 'text', text = ' after'},
    }
    assert.same(expected, ast)
  end)
end)

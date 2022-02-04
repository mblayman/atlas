local assert = require "luassert.assert"

local Parser = require "atlas.templates.parser"

describe("Parser", function()
  it("constructs an instance", function()
    local parser = Parser()

    assert.equal(Parser, getmetatable(parser))
  end)

  it("parses raw text to an AST", function()
    local parser = Parser()
    local source = "hello template"

    local ast = parser:parse(source)

    assert.same({{node_type = "text", text = "hello template"}}, ast)
  end)

  it("parses an expression to an AST #xfail", function()
    local parser = Parser()
    local source = "before {{ variable }} after"

    local ast = parser:parse(source)

    local expected = {
      {node_type = "text", text = "before "},
      {node_type = "expression", expression = "variable "},
      {node_type = "text", text = " after"},
    }
    assert.same(expected, ast)
  end)

  it("parses an expression single quoted literal to an AST", function()
    local parser = Parser()
    local source = "before {{ 'hello' }} after"

    local ast = parser:parse(source)

    local expected = {
      {node_type = "text", text = "before "}, {node_type = "text", text = "hello"},
      {node_type = "text", text = " after"},
    }
    assert.same(expected, ast)
  end)

  it("parses an expression double quoted literal to an AST", function()
    local parser = Parser()
    local source = "before {{ \"hello\" }} after"

    local ast = parser:parse(source)

    local expected = {
      {node_type = "text", text = "before "}, {node_type = "text", text = "hello"},
      {node_type = "text", text = " after"},
    }
    assert.same(expected, ast)
  end)

  it("parses an expression literal with newline to an AST", function()
    local parser = Parser()
    local source = [[before {{ "hello
world" }} after]]

    local ast = parser:parse(source)

    local expected = {
      {node_type = "text", text = "before "},
      {node_type = "text", text = "hello\nworld"},
      {node_type = "text", text = " after"},
    }
    assert.same(expected, ast)
  end)

  it("parses a nil expression", function()
    local parser = Parser()
    local source = "{{ nil }}la wafer"

    local ast = parser:parse(source)

    local expected = {
      {node_type = "symbol", symbol = "nil"}, {node_type = "text", text = "la wafer"},
    }
    assert.same(expected, ast)
  end)

  it("parses a false expression", function()
    local parser = Parser()
    local source = "{{ false }} flag"

    local ast = parser:parse(source)

    local expected = {
      {node_type = "symbol", symbol = "false"}, {node_type = "text", text = " flag"},
    }
    assert.same(expected, ast)
  end)

  it("parses a true expression", function()
    local parser = Parser()
    local source = "{{ true }}r words"

    local ast = parser:parse(source)

    local expected = {
      {node_type = "symbol", symbol = "true"}, {node_type = "text", text = "r words"},
    }
    assert.same(expected, ast)
  end)

  it("parses an integer expression", function()
    local parser = Parser()
    local source = "{{ 42 }} is the answer."

    local ast = parser:parse(source)

    local expected = {
      {node_type = "numeral", numeral = "42"},
      {node_type = "text", text = " is the answer."},
    }
    assert.same(expected, ast)
  end)

  it("parses a float expression", function()
    local parser = Parser()
    local source = "Pi is {{ 3.14 }}"

    local ast = parser:parse(source)

    local expected = {
      {node_type = "text", text = "Pi is "}, {node_type = "numeral", numeral = "3.14"},
    }
    assert.same(expected, ast)
  end)

end)

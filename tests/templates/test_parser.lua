local assert = require "luassert"

local Parser = require "atlas.templates.parser"

local tests = {}

-- Parser constructs an instance
function tests.test_constructor()
  local parser = Parser()

  assert.equal(Parser, getmetatable(parser))
end

-- Parser parses raw text to an AST
function tests.test_parse_raw_text()
  local parser = Parser()
  local source = "hello template"

  local ast = parser:parse(source)

  assert.same({{node_type = "text", text = "hello template"}}, ast)
end

-- Parser parses an expression to an AST
function tests.test_parse_expression()
  local parser = Parser()
  local source = "before {{ variable }} after"

  local _ = parser:parse(source) -- unused is "ast"

  -- xfail
  -- local expected = {
  --   {node_type = "text", text = "before "},
  --   {node_type = "expression", expression = "variable "},
  --   {node_type = "text", text = " after"},
  -- }
  -- assert.same(expected, ast)
end

-- Parser parses an expression single quoted literal to an AST
function tests.test_parse_single_quote_literal()
  local parser = Parser()
  local source = "before {{ 'hello' }} after"

  local ast = parser:parse(source)

  local expected = {
    {node_type = "text", text = "before "}, {node_type = "text", text = "hello"},
    {node_type = "text", text = " after"},
  }
  assert.same(expected, ast)
end

-- Parser parses an expression double quoted literal to an AST
function tests.test_parse_double_quote_literal()
  local parser = Parser()
  local source = "before {{ \"hello\" }} after"

  local ast = parser:parse(source)

  local expected = {
    {node_type = "text", text = "before "}, {node_type = "text", text = "hello"},
    {node_type = "text", text = " after"},
  }
  assert.same(expected, ast)
end

-- Parser parses an expression literal with newline to an AST
function tests.test_parse_literal_newline()
  local parser = Parser()
  local source = [[before {{ "hello
world" }} after]]

  local ast = parser:parse(source)

  local expected = {
    {node_type = "text", text = "before "}, {node_type = "text", text = "hello\nworld"},
    {node_type = "text", text = " after"},
  }
  assert.same(expected, ast)
end

-- Parser parses a nil expression
function tests.test_parse_nil_expression()
  local parser = Parser()
  local source = "{{ nil }}la wafer"

  local ast = parser:parse(source)

  local expected = {
    {node_type = "symbol", symbol = "nil"}, {node_type = "text", text = "la wafer"},
  }
  assert.same(expected, ast)
end

-- Parser parses a false expression
function tests.test_parse_false_expression()
  local parser = Parser()
  local source = "{{ false }} flag"

  local ast = parser:parse(source)

  local expected = {
    {node_type = "symbol", symbol = "false"}, {node_type = "text", text = " flag"},
  }
  assert.same(expected, ast)
end

-- Parser parses a true expression
function tests.test_parse_true_expression()
  local parser = Parser()
  local source = "{{ true }}r words"

  local ast = parser:parse(source)

  local expected = {
    {node_type = "symbol", symbol = "true"}, {node_type = "text", text = "r words"},
  }
  assert.same(expected, ast)
end

-- Parser parses an integer expression
function tests.test_parse_integer_expression()
  local parser = Parser()
  local source = "{{ 42 }} is the answer."

  local ast = parser:parse(source)

  local expected = {
    {node_type = "numeral", numeral = "42"},
    {node_type = "text", text = " is the answer."},
  }
  assert.same(expected, ast)
end

-- Parser parses a float expression
function tests.test_parse_float_expression()
  local parser = Parser()
  local source = "Pi is {{ 3.14 }}"

  local ast = parser:parse(source)

  local expected = {
    {node_type = "text", text = "Pi is "}, {node_type = "numeral", numeral = "3.14"},
  }
  assert.same(expected, ast)
end

-- Parser unary operator expression parses the unary minus
function tests.test_unary_operator_minus()
  local parser = Parser()
  local source = "A negative number of {{ -42 }}"

  local ast = parser:parse(source)

  local expected = {
    {node_type = "text", text = "A negative number of "}, {
      node_type = "unary_operator",
      unary_operator = "-",
      operand = {node_type = "numeral", numeral = "42"},
    },
  }
  assert.same(expected, ast)
end

return tests

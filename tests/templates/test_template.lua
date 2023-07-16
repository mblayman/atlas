local assert = require "luassert"

local Template = require "atlas.templates.template"

local tests = {}

-- Template constructs an instance
function tests.test_constructor()
  local context = {}
  local template = Template("hello", context)

  assert.equal(getmetatable(template), Template)
  assert.equal("hello", template._source)
  assert.equal(context, template._context)
  assert.equal(nil, template._renderer)
end

-- Template parses a renderer
function tests.test_parses_renderer()
  local template = Template("hello", {})

  template:parse()

  assert.truthy(template._renderer)
end

-- Template renders an empty template
function tests.test_empty_template()
  local template = Template("", {}):parse()
  local context = {}

  local actual = template:render(context)

  assert.equal("", actual)
end

-- Template renders a literal string
function tests.test_render_literal()
  local template = Template("hello", {}):parse()
  local context = {}

  local actual = template:render(context)

  assert.equal("hello", actual)
end

-- Template renders a literal multi-line string
function tests.test_render_literal_multiline()
  local template = Template([[
hello
world]], {}):parse()
  local context = {}

  local actual = template:render(context)

  assert.equal("hello\nworld", actual)
end

-- Template renders a basic expression variable
function tests.test_render_variable_expression()
  local template = Template("The answer is {{ count }}.", {}):parse()
  local context = {count = 42}

  local _ = template:render(context) -- unused is "actual"

  -- xfail
  -- assert.equal("The answer is 42.", actual)
end

-- Template renders a literal string with literal expressions
function tests.test_render_literal_expression()
  local template = Template([[template {{ '{{' }} inception {{ '}}' }}]], {}):parse()
  local context = {count = 42}

  local actual = template:render(context)

  assert.equal("template {{ inception }}", actual)
end

-- Template renders a nil expression
function tests.test_render_nil_expression()
  local template = Template("{{ nil }}", {}):parse()
  local context = {}

  local actual = template:render(context)

  assert.equal("nil", actual)
end

-- Template renders a false expression
function tests.test_render_false_expression()
  local template = Template("{{ false }}", {}):parse()
  local context = {}

  local actual = template:render(context)

  assert.equal("false", actual)
end

-- Template renders a true expression
function tests.test_render_true_expression()
  local template = Template("{{ true }}", {}):parse()
  local context = {}

  local actual = template:render(context)

  assert.equal("true", actual)
end

-- Template renders an integer expression
function tests.test_render_integer_expression()
  local template = Template("{{ 42 }} is the answer.", {}):parse()
  local context = {}

  local actual = template:render(context)

  assert.equal("42 is the answer.", actual)
end

-- Template renders a float expression
function tests.test_render_float_expression()
  local template = Template("Pi is {{ 3.14 }}", {}):parse()
  local context = {}

  local actual = template:render(context)

  assert.equal("Pi is 3.14", actual)
end

-- Template renders a float without a fraction expression
function tests.test_render_float_expression_no_fraction()
  local template = Template("{{ 8. }} is still a float.", {}):parse()
  local context = {}

  local actual = template:render(context)

  assert.equal("8.0 is still a float.", actual)
end

-- Template renders dotted access expression variable
function tests.test_render_dotted_access_expression()
  -- {{ foo.bar }}
end

-- Template renders subscript expression variable
function tests.test_render_subscript_expression()
  -- {{ foo['bar'] }}
end

-- Template renders a function expression
function tests.test_render_function_expression()
  -- {{ foo('42') }}
end

-- Template renders a expression variable method
function tests.test_render_method_expression()
  -- {{ foo.bar(baz) }}
end

-- Template renders with undefined variables
function tests.test_render_undefined_variables()
  -- render as an empty string.
end

-- Template errors when undefined is used in an expression
function tests.test_undefined_expression_error()
  -- when undefined is used with something like addition, return an error.
end

-- Template renders with different data
function tests.test_render_different_data()
  -- Different data will render with different results.
end

return tests

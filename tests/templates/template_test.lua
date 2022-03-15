local assert = require "luassert.assert"

local Template = require "atlas.templates.template"

describe("Template", function()

  it("constructs an instance", function()
    local context = {}
    local template = Template("hello", context)

    assert.equal(getmetatable(template), Template)
    assert.equal("hello", template._source)
    assert.equal(context, template._context)
    assert.equal(nil, template._renderer)
  end)

  it("parses a renderer", function()
    local template = Template("hello", {})

    template:parse()

    assert.truthy(template._renderer)
  end)

  it("renders an empty template", function()
    local template = Template("", {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal("", actual)
  end)

  it("renders a literal string", function()
    local template = Template("hello", {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal("hello", actual)
  end)

  it("renders a literal multi-line string", function()
    local template = Template([[
hello
  world]], {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal("hello\n  world", actual)
  end)

  it("renders a basic expression variable #xfail", function()
    local template = Template("The answer is {{ count }}.", {}):parse()
    local context = {count = 42}

    local actual = template:render(context)

    assert.equal("The answer is 42.", actual)
  end)

  it("renders a literal string with literal expressions", function()
    local template = Template([[template {{ '{{' }} inception {{ '}}' }}]], {}):parse()
    local context = {count = 42}

    local actual = template:render(context)

    assert.equal("template {{ inception }}", actual)
  end)

  it("renders a nil expression", function()
    local template = Template("{{ nil }}", {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal("nil", actual)
  end)

  it("renders a false expression", function()
    local template = Template("{{ false }}", {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal("false", actual)
  end)

  it("renders a true expression", function()
    local template = Template("{{ true }}", {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal("true", actual)
  end)

  it("renders an integer expression", function()
    local template = Template("{{ 42 }} is the answer.", {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal("42 is the answer.", actual)
  end)

  it("renders a float expression", function()
    local template = Template("Pi is {{ 3.14 }}", {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal("Pi is 3.14", actual)
  end)

  it("renders a float without a fraction expression", function()
    local template = Template("{{ 8. }} is still a float.", {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal("8.0 is still a float.", actual)
  end)

  it("renders dotted access expression variable", function()
    -- {{ foo.bar }}
  end)

  it("renders subscript expression variable", function()
    -- {{ foo['bar'] }}
  end)

  it("renders a function expression", function()
    -- {{ foo('42') }}
  end)

  it("renders a expression variable method", function()
    -- {{ foo.bar(baz) }}
  end)

  it("renders with undefined variables", function()
    -- render as an empty string.
  end)

  it("errors when undefined is used in an expression", function()
    -- when undefined is used with something like addition, return an error.
  end)

  it("renders with different data", function()
    -- Different data will render with different results.
  end)

end)

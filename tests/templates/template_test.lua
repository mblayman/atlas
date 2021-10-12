local Template = require 'atlas.templates.template'

describe('Template', function()

  it('constructs an instance', function()
    local context = {}
    local template = Template('hello', context)

    assert.equal(getmetatable(template), Template)
    assert.equal('hello', template._source)
    assert.equal(context, template._context)
    assert.equal(nil, template._renderer)
  end)

  it('parses a renderer', function()
    local template = Template('hello', {})

    template:parse()

    assert.truthy(template._renderer)
  end)

  it('renders an empty template', function()
    local template = Template('', {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal('', actual)
  end)

  it('renders a literal string', function()
    local template = Template('hello', {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal('hello', actual)
  end)

  it('renders a literal multi-line string', function()
    local template = Template([[
hello
  world]], {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal('hello\n  world', actual)
  end)

  it('renders a basic expression variable #fit', function()
    local template = Template('The answer is {{ count }}.', {}):parse()
    local context = {count = 42}

    local actual = template:render(context)

    assert.equal('The answer is 42.', actual)
  end)

  it('renders a literal string', function()
    -- TODO: `{{ '{{' }}`
  end)

  it('renders dotted access expression variable', function()
    -- TODO
  end)

  it('renders subscript expression variable', function()
    -- TODO
  end)

  it('renders with undefined variables', function()
    -- TODO: render as an empty string.
  end)

  it('errors when undefined is used in an expression', function()
    -- TODO: when undefined is used with something like addition, return an error.
  end)

  it('renders with different data', function()
    -- Different data will render with different results.
    -- TODO
  end)

end)

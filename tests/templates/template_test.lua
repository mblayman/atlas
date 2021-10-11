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

  it('renders a raw string', function()
    local template = Template('hello', {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal('hello', actual)
  end)

  it('renders a raw multi-line string #fit', function()
    local template = Template([[
hello
  world]], {}):parse()
    local context = {}

    local actual = template:render(context)

    assert.equal('hello\n  world', actual)
  end)

  it('renders expressions', function()
    -- TODO
  end)

  it('renders with undefined variables', function()
    -- TODO: What behavior do I want? Error or pass silently?
  end)

  it('renders with different data', function()
    -- Different data will render with different results.
    -- TODO
  end)

end)

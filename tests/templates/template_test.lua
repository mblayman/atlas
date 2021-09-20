local Template = require 'atlas.templates.template'

describe('Template', function()

  it('constructs an instance', function()
    local template = Template('hello')

    assert.equal(getmetatable(template), Template)
    assert.equal(template._source, 'hello')
    assert.equal(template._renderer, nil)
  end)

  it('parses a renderer', function()
    local template = Template('hello')

    template:parse()

    assert.truthy(template._renderer)
  end)

  it('renders a raw string', function()
    local template = Template('hello')
    local context = {}

    local actual = template.render(context)

    assert.equal(actual, 'hello')
  end)

  it('renders variables', function()
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

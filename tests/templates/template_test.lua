local Template = require 'atlas.templates.template'

describe('Template', function()
  it('constructs an instance', function()
    local template = Template('hello')

    assert.are.equal(getmetatable(template), Template)
    assert.are.equal(template.source, 'hello')
  end)
end)

local Environment = require 'atlas.templates.environment'

describe('Environment', function()
  it('constructs an instance', function()
    local environment = Environment()

    assert.are.equal(Environment, getmetatable(environment))
  end)
end)

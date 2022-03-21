local assert = require "luassert.assert"

local Environment = require "atlas.templates.environment"

describe("Environment", function()

  it("constructs an instance", function()
    local environment = Environment()

    assert.equal(Environment, getmetatable(environment))
  end)

end)

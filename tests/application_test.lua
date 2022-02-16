local assert = require "luassert.assert"

local Application = require "atlas.application"

describe("Application", function()

  it("constructs an instance", function()
    local app = Application()

    assert.equal(getmetatable(app), Application)
  end)

  it("is callable", function()
    local app = Application()

    local ret = app()

    assert.is_true(ret)
  end)
end)

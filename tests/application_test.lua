local assert = require "luassert.assert"

local Application = require "atlas.application"

describe("Application", function()

  it("constructs an instance", function()
    local app = Application()

    assert.equal(getmetatable(app), Application)
  end)

  it("is callable", function()
    local app = Application()
    local scope = {}
    local receive = function() end
    local send = function() end

    local ret = app(scope, receive, send)

    assert.is_true(ret)
  end)
end)

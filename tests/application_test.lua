local assert = require "luassert.assert"

local Application = require "atlas.application"

describe("Application", function()

  it("constructs an instance", function()
    local routes = {}
    local app = Application(routes)

    assert.equal(getmetatable(app), Application)
    assert.is_not_nil(app.router)
  end)

  it("is callable", function()
    local routes = {}
    local app = Application(routes)
    local scope = {}
    local receive = function() end
    local send = function() end

    local ret = app(scope, receive, send)

    assert.is_true(ret)
  end)
end)

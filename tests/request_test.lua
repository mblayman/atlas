local assert = require "luassert.assert"

local Request = require "atlas.request"
local asgi = require "atlas.test.asgi"

describe("Request", function()

  it("constructs an instance", function()
    local scope = {}
    local request = Request(scope)

    assert.equal(getmetatable(request), Request)
    assert.equal(scope, request.scope)
  end)

  it("proxies the scope path", function()
    local scope = asgi.make_scope()
    local request = Request(scope)

    assert.same(scope.path, request.path)
  end)
end)

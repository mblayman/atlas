local assert = require "luassert.assert"

local Request = require "atlas.request"

describe("Request", function()

  it("constructs an instance", function()
    local scope = {}
    local request = Request(scope)

    assert.equal(getmetatable(request), Request)
    assert.equal(scope, request.scope)
  end)

end)

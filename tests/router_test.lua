local assert = require "luassert.assert"

local Router = require "atlas.router"

describe("Router", function()

  it("constructs an instance", function()
    local routes = {}
    local router = Router(routes)

    assert.equal(getmetatable(router), Router)
  end)

  it("has routes", function()
    local routes = {}
    local router = Router(routes)

    assert.equal(routes, router.routes)
  end)

  it("finds a route matching a path", function()
    local expected_route = {matches = function() return true end}
    local routes = {expected_route}
    local router = Router(routes)

    local match, route = router:route("GET", "/")

    assert.is_true(match)
    assert.equal(expected_route, route)
  end)

  it("fails to find a path with no matching route", function()
    local routes = {}
    local router = Router(routes)

    local match, route = router:route("GET", "/")

    assert.is_false(match)
    assert.is_nil(route)
  end)
end)

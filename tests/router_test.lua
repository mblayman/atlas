local assert = require "luassert.assert"

local Router = require "atlas.router"
local Match = require "atlas.match"

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
    local expected_route = {matches = function() return Match.FULL end}
    local routes = {expected_route}
    local router = Router(routes)

    local match, route = router:route("GET", "/")

    assert.same(Match.FULL, match)
    assert.equal(expected_route, route)
  end)

  it("finds a route partially matching a path", function()
    local expected_route = {matches = function() return Match.PARTIAL end}
    local routes = {expected_route}
    local router = Router(routes)

    local match, route = router:route("GET", "/")

    assert.same(Match.PARTIAL, match)
    assert.equal(expected_route, route)
  end)

  it("fails to find a path with no matching route", function()
    local routes = {}
    local router = Router(routes)

    local match, route = router:route("GET", "/")

    assert.same(Match.NONE, match)
    assert.is_nil(route)
  end)
end)

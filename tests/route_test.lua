local assert = require "luassert.assert"

local Route = require "atlas.route"
local Match = require "atlas.match"
local FULL, PARTIAL = Match.FULL, Match.PARTIAL

describe("Route", function()

  it("constructs an instance", function()
    local controller = function() end
    local route = Route("/", controller, {"GET", "POST"})

    assert.equal(getmetatable(route), Route)
    assert.same("/", route.path)
    assert.equal(controller, route.controller)
    assert.same({"GET", "POST"}, route.methods)
  end)

  it("defaults a methods table", function()
    local controller = function() end
    local route = Route("/", controller)

    assert.same({"GET"}, route.methods)
  end)

  it("matches fully", function()
    local controller = function() end
    local route = Route("/", controller)

    local match = route:matches("GET", "/")

    assert.same(FULL, match)
  end)

  it("matches partially", function()
    local controller = function() end
    local route = Route("/", controller, {"POST"})

    local match = route:matches("GET", "/")

    assert.same(PARTIAL, match)
  end)

  it("matches with string parameter", function()
    local controller = function() end
    local route = Route("/users/{username:string}", controller)

    local match = route:matches("GET", "/users/matt")

    assert.same(FULL, match)
  end)

  it("matches with int parameter", function()
    local controller = function() end
    local route = Route("/users/{id:int}", controller)

    local match = route:matches("GET", "/users/42")

    assert.same(FULL, match)
  end)

  it("matches with multiple parameters", function()
    local controller = function() end
    local route = Route("/users/{username:string}/posts/{id:int}/likes", controller)

    local match = route:matches("GET", "/users/matt/posts/42/likes")

    assert.same(FULL, match)
  end)

  it("matches with no parameters", function()
    local controller = function() end
    local route = Route("/users", controller)

    local match = route:matches("GET", "/users")

    assert.same(FULL, match)
  end)

  it("generates path pattern with one parameter", function()
    local controller = function() end
    local route = Route("/users/{id:int}", controller)

    assert.same("^/users/([%d]*)$", route.path_pattern)
  end)

  it("generates path pattern with multiple parameters", function()
    local controller = function() end
    local route = Route("/users/{username:string}/posts/{id:int}", controller)

    assert.same("^/users/([^/]*)/posts/([%d]*)$", route.path_pattern)
  end)

  it("fails with an unknown converter", function()
    local controller = function() end
    local status, message = pcall(Route, "/users/{id:nope}", controller)

    assert.is_false(status)
    assert.is_not_nil(string.find(message, "Unknown converter type: nope", 1, true))
  end)
end)

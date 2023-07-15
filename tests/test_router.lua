local assert = require "luassert"

local Router = require "atlas.router"
local Match = require "atlas.match"

local tests = {}

-- Router constructs an instance
function tests.test_constructor()
  local routes = {}
  local router = Router(routes)

  assert.equal(getmetatable(router), Router)
end

-- Router has routes
function tests.test_has_routes()
  local routes = {}
  local router = Router(routes)

  assert.equal(routes, router.routes)
end

-- Router finds a route matching a path
function tests.test_route()
  local expected_route = {matches = function() return Match.FULL end}
  local routes = {expected_route}
  local router = Router(routes)

  local match, route = router:route("GET", "/")

  assert.same(Match.FULL, match)
  assert.equal(expected_route, route)
end

-- Router finds a route partially matching a path
function tests.test_route_partial()
  local expected_route = {matches = function() return Match.PARTIAL end}
  local routes = {expected_route}
  local router = Router(routes)

  local match, route = router:route("GET", "/")

  assert.same(Match.PARTIAL, match)
  assert.equal(expected_route, route)
end

-- Router fails to find a path with no matching route
function tests.test_route_no_match()
  local routes = {}
  local router = Router(routes)

  local match, route = router:route("GET", "/")

  assert.same(Match.NONE, match)
  assert.is_nil(route)
end

return tests

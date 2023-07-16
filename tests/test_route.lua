local assert = require "luassert"

local Route = require "atlas.route"
local Match = require "atlas.match"
local assertions = require "atlas.test.assertions"
local FULL, PARTIAL = Match.FULL, Match.PARTIAL

local tests = {}

-- Route constructs an instance
function tests.test_constructor()
  local controller = function() end
  local route = Route("/", controller, {"GET", "POST"})

  assert.equal(getmetatable(route), Route)
  assert.same("/", route.path)
  assert.equal(controller, route.controller)
  assert.same({"GET", "POST"}, route.methods)
end

-- Route defaults a methods table
function tests.test_defaults()
  local controller = function() end
  local route = Route("/", controller)

  assert.same({"GET"}, route.methods)
end

-- Route matches fully
function tests.test_full_match()
  local controller = function() end
  local route = Route("/", controller)

  local match = route:matches("GET", "/")

  assert.same(FULL, match)
end

-- Route matches partially
function tests.test_partial_match()
  local controller = function() end
  local route = Route("/", controller, {"POST"})

  local match = route:matches("GET", "/")

  assert.same(PARTIAL, match)
end

-- Route matches with string parameter
function tests.test_match_string_parameter()
  local controller = function() end
  local route = Route("/users/{username:string}", controller)

  local match = route:matches("GET", "/users/matt")

  assert.same(FULL, match)
end

-- Route matches with int parameter
function tests.test_match_int_parameter()
  local controller = function() end
  local route = Route("/users/{id:int}", controller)

  local match = route:matches("GET", "/users/42")

  assert.same(FULL, match)
end

-- Route matches with multiple parameters
function tests.test_match_multiple_parameters()
  local controller = function() end
  local route = Route("/users/{username:string}/posts/{id:int}/likes", controller)

  local match = route:matches("GET", "/users/matt/posts/42/likes")

  assert.same(FULL, match)
end

-- Route matches with no parameters
function tests.test_match_no_parameters()
  local controller = function() end
  local route = Route("/users", controller)

  local match = route:matches("GET", "/users")

  assert.same(FULL, match)
  assert.same({}, route.converters)
end

-- Route generates path pattern with one parameter
function tests.test_one_parameter_pattern()
  local controller = function() end
  local route = Route("/users/{id:int}", controller)

  assert.same("^/users/([%d]*)$", route.path_pattern)
  assert.same({"int"}, route.converters)
end

-- Route generates path pattern with multiple parameters
function tests.test_multiple_parameters_pattern()
  local controller = function() end
  local route = Route("/users/{username:string}/posts/{id:int}", controller)

  assert.same("^/users/([^/]*)/posts/([%d]*)$", route.path_pattern)
  assert.same({"string", "int"}, route.converters)
end

-- Route fails with an unknown converter
function tests.test_unknown_converter()
  local controller = function() end
  local status, message = pcall(Route, "/users/{id:nope}", controller)

  assert.is_false(status)
  assertions.contains("Unknown converter type: nope", message)
end

-- Route send parameters to the controller
function tests.test_send_parameters()
  local request = {path = "/users/matt/posts/42/likes"}
  local response = {}
  local actual_username, actual_id
  local controller = function(_, username, id)
    actual_username = username
    actual_id = id
    return response
  end
  local route = Route("/users/{username:string}/posts/{id:int}/likes", controller)

  local actual_response = route:run(request)

  assert.same("matt", actual_username)
  assert.same(42, actual_id)
  assert.equal(response, actual_response)
end

return tests

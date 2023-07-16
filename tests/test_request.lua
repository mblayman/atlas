local assert = require "luassert"

local Request = require "atlas.request"
local asgi = require "atlas.test.asgi"

local tests = {}

-- Request constructs an instance
function tests.test_constructor()
  local scope = {}
  local request = Request(scope)

  assert.equal(getmetatable(request), Request)
  assert.equal(scope, request.scope)
end

-- Request proxies the scope path
function tests.test_proxies_path()
  local scope = asgi.make_scope()
  local request = Request(scope)

  assert.same(scope.path, request.path)
end

return tests

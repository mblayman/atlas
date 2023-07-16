local assert = require "luassert"
local spy = require "luassert.spy"

local Application = require "atlas.application"
local Response = require "atlas.response"
local Route = require "atlas.route"
local asgi = require "atlas.test.asgi"

local tests = {}

-- Application constructs an instance
function tests.test_constructor()
  local routes = {}
  local app = Application(routes)

  assert.equal(getmetatable(app), Application)
  assert.is_not_nil(app.router)
end

-- Application is callable
function tests.test_callable()
  local app = Application({})
  local receive = function() end
  local called = false
  local send = function() called = true end

  app(asgi.make_scope(), receive, send)

  assert.is_true(called)
end

-- Application handles a full match
function tests.test_full_match()
  local routes = {Route("/", function() return Response() end)}
  local app = Application(routes)
  local receive = function() end
  local send = spy.new(function() end)

  app(asgi.make_scope(), receive, send)

  assert.spy(send).called_with({
    type = "http.response.start",
    status = 200,
    headers = {{"content-type", "text/html"}},
  })
end

-- Application handles a partial match
function tests.test_partial_match()
  local routes = {Route("/", function() end)}
  local app = Application(routes)
  local scope = asgi.make_scope()
  scope.method = "POST"
  local receive = function() end
  local send = spy.new(function() end)

  app(scope, receive, send)

  assert.spy(send).called_with({
    type = "http.response.start",
    status = 405,
    headers = {{"content-type", "text/html"}},
  })
end

-- Application handles a none match
function tests.test_none_match()
  local routes = {Route("/asdf", function() end)}
  local app = Application(routes)
  local scope = asgi.make_scope()
  scope.method = "POST"
  local receive = function() end
  local send = spy.new(function() end)

  app(scope, receive, send)

  assert.spy(send).called_with({
    type = "http.response.start",
    status = 404,
    headers = {{"content-type", "text/html"}},
  })
end

return tests

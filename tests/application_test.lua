local assert = require "luassert.assert"
local spy = require "luassert.spy"

local Application = require "atlas.application"
local Response = require "atlas.response"
local Route = require "atlas.route"
local asgi = require "atlas.test.asgi"

describe("Application", function()

  it("constructs an instance", function()
    local routes = {}
    local app = Application(routes)

    assert.equal(getmetatable(app), Application)
    assert.is_not_nil(app.router)
  end)

  it("is callable", function()
    local app = Application({})
    local receive = function() end
    local called = false
    local send = function() called = true end

    app(asgi.make_scope(), receive, send)

    assert.is_true(called)
  end)

  it("handles a full match", function()
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
  end)

  it("handles a partial match", function()
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
  end)

  it("handles a none match", function()
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
  end)
end)

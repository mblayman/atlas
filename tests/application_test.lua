local assert = require "luassert.assert"

local Application = require "atlas.application"
local Route = require "atlas.route"

local function make_scope()
  return {
    type = "http",
    asgi = {version = "3.0", spec_version = "2.3"},
    http_version = "1.1",
    method = "GET",
    scheme = "http",
    path = "/",
    raw_path = "/",
    query_string = "",
    root_path = "",
    headers = {},
    -- TODO: what should these be?
    client = {"127.0.0.1", 8000},
    server = {"127.0.0.1", 8000},
  }
end

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

    app(make_scope(), receive, send)

    assert.is_true(called)
  end)

  it("handles a full match", function()
    local routes = {Route("/", function() end)}
    local app = Application(routes)
    local receive = function() end
    local called = false
    local send = function() called = true end

    app(make_scope(), receive, send)

    -- TODO: check for 200
    assert.is_true(called)
  end)

  it("handles a partial match", function()
    local routes = {Route("/", function() end)}
    local app = Application(routes)
    local scope = make_scope()
    scope.method = "POST"
    local receive = function() end
    local called = false
    local send = function() called = true end

    app(scope, receive, send)

    -- TODO: check for 405
    assert.is_true(called)
  end)

  it("handles a none match", function()
    local routes = {Route("/asdf", function() end)}
    local app = Application(routes)
    local scope = make_scope()
    scope.method = "POST"
    local receive = function() end
    local called = false
    local send = function() called = true end

    app(scope, receive, send)

    -- TODO: check for 404
    assert.is_true(called)
  end)
end)

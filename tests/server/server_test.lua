local assert = require "luassert.assert"
local stub = require "luassert.stub"

local main = require "atlas.server.main"
local Server = require "atlas.server.server"
local assertions = require "atlas.test.assertions"
local loop = require "atlas.test.loop"

local function build_mock_server()
  return {
    accept = function(_) return nil, nil end, -- arg is a client
    bind = function() return 0 end,
    listen = function() return 0 end,
  }
end

describe("Server", function()
  it("constructs an instance", function()
    local server = Server()

    assert.equal(Server, getmetatable(server))
  end)

  it("runs the event loop", function()
    local server = Server()

    local has_active_handles = server:run()

    assert.is_false(has_active_handles)
  end)

  it("creates a TCP server", function()
    local server = Server()

    local status = server:_make_tcp_server()

    assert.equal(0, status)
  end)

  it("sets up the TCP server", function()
    local server = Server()
    stub(server, "_make_tcp_server").returns(0)
    server._server = build_mock_server()
    local config = {host = "127.0.0.1", port = 5555}

    local status = server:set_up(config)

    assert.equal(0, status)
    loop.close()
  end)

  it("listens via the callback", function()
    local luv = require "luv"
    local err = nil
    local server = Server()
    server._server = build_mock_server()
    local mock_client = {read_start = function() end}
    stub(mock_client, "read_start")
    stub(luv, "new_tcp").returns(mock_client)

    local callback = server:_make_listen_callback()
    callback(err)

    assert.stub(mock_client.read_start).called()
  end)

  it("exits on sigint", function()
    stub(_G.os, "exit")

    Server.on_sigint(nil)

    assert.stub(_G.os.exit).called_with(0)
  end)

  it("fails on a signal creation error", function()
    local luv = require "luv"
    stub(luv, "new_signal").returns(nil, 1)
    local server = Server()

    local status
    loop.run_until_done(function() status = server:_set_sigint() end)

    assert.equal(1, status)
  end)

  it("fails on TCP creation error", function()
    local luv = require "luv"
    stub(luv, "new_tcp").returns(nil, 1)
    local server = Server()

    local status
    loop.run_until_done(function() status = server:_make_tcp_server() end)

    assert.equal(1, status)
  end)

  it("fails on bind error", function()
    local server = Server()
    server._server = build_mock_server()
    stub(server._server, "bind").returns(42, nil)

    local status
    loop.run_until_done(function() status = server:_bind("127.0.0.1", 5000) end)

    assert.equal(42, status)
  end)

  it("fails on listen error", function()
    local server = Server()
    server._server = build_mock_server()
    stub(server._server, "listen").returns(42, nil)

    local status
    loop.run_until_done(function() status = server:_listen() end)

    assert.equal(42, status)
  end)
end)

describe("main", function()
  it("runs", function()
    local server = Server()
    stub(server, "_make_tcp_server").returns(0)
    stub(server, "run").returns(false)
    server._server = build_mock_server()
    local config = {host = "127.0.0.1", port = 5555}
    local app = {}

    local status = main.run(config, server, app)

    assert.equal(1, status)
    loop.close()
  end)

  it("fails on server setup failure", function()
    local server = {set_up = function() return 42 end}
    local config = {host = "127.0.0.1", port = 5555}
    local app = {}

    local status = main.run(config, server, app)

    assert.equal(42, status)
  end)

  it("fails when active handles persist", function()
    local server = {set_up = function() return 0 end, run = function() return 1 end}
    local config = {host = "127.0.0.1", port = 5555}
    local app = {}

    local status = main.run(config, server, app)

    assert.equal(1, status)
  end)

  it("loads an app", function()
    local server = {set_up = function() return 0 end, run = function() return false end}
    local config = {host = "127.0.0.1", port = 5555, app = "app.main:app"}

    local status = main.run(config, server)

    assert.equal(0, status)
  end)

  it("fails when there is no app", function()
    local server = {set_up = function() return 0 end, run = function() return false end}
    local config = {host = "127.0.0.1", port = 5555, app = "app.main:app_not_here"}

    local status, message = pcall(main.run, config, server)

    assert.is_false(status)
    assertions.contains("No app named 'app_not_here' found in module 'app.main'",
                        message)
  end)

end)

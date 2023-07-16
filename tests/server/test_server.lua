local assert = require "luassert"
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

local tests = {}

-- Server constructs an instance
function tests.test_server_constructor()
  local server = Server()

  assert.equal(Server, getmetatable(server))
end

-- Server runs the event loop
function tests.test_server_runs()
  local server = Server()
  local luv = require "luv"
  stub(luv, "run").returns(false)

  local has_active_handles = server:run()

  assert.is_false(has_active_handles)
  luv.run:revert()
end

-- Server creates a TCP server
function tests.test_makes_tcp_server()
  local server = Server()
  local luv = require "luv"
  stub(luv, "new_tcp").returns({}, nil)

  local status = server:_make_tcp_server()

  assert.equal(0, status)
  luv.new_tcp:revert()
end

-- Server sets up the TCP server
function tests.test_tcp_server_set_up()
  local server = Server()
  stub(server, "_make_tcp_server").returns(0)
  stub(server, "_set_sigint").returns(0)
  server._server = build_mock_server()
  local config = {host = "127.0.0.1", port = 5555}

  local status = server:set_up(config)

  assert.equal(0, status)
  loop.close()
end

-- Server listens via the callback
function tests.test_server_listens()
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
  luv.new_tcp:revert()
end

-- Server exits on sigint
function tests.test_sigint()
  stub(_G.os, "exit")

  Server.on_sigint(nil)

  assert.stub(_G.os.exit).called_with(0)
  _G.os.exit:revert()
end

-- Server fails on a signal creation error
function tests.test_signal_creation_error()
  local luv = require "luv"
  stub(luv, "new_signal").returns(nil, 1)
  local server = Server()

  local status
  loop.run_until_done(function() status = server:_set_sigint() end)

  assert.equal(1, status)
  luv.new_signal:revert()
end

-- Server fails on TCP creation error
function tests.test_tcp_creation_error()
  local luv = require "luv"
  stub(luv, "new_tcp").returns(nil, 1)
  local server = Server()

  local status
  loop.run_until_done(function() status = server:_make_tcp_server() end)

  assert.equal(1, status)
  luv.new_tcp:revert()
end

-- Server fails on bind error
function tests.test_bind_error()
  local server = Server()
  server._server = build_mock_server()
  stub(server._server, "bind").returns(42, nil)

  local status
  loop.run_until_done(function() status = server:_bind("127.0.0.1", 5000) end)

  assert.equal(42, status)
end

-- Server fails on listen error
function tests.test_listen_error()
  local server = Server()
  server._server = build_mock_server()
  stub(server._server, "listen").returns(42, nil)

  local status
  loop.run_until_done(function() status = server:_listen() end)

  assert.equal(42, status)
end

-- main runs
function tests.test_main_runs()
  local server = Server()
  stub(server, "set_up").returns(0)
  stub(server, "run").returns(false)
  server._server = build_mock_server()
  local config = {host = "127.0.0.1", port = 5555}
  local app = {}

  local status = main.run(config, server, app)

  assert.equal(0, status)
  loop.close()
end

-- main fails on server setup failure
function tests.test_main_server_setup_failure()
  local server = {set_up = function() return 42 end}
  local config = {host = "127.0.0.1", port = 5555}
  local app = {}

  local status = main.run(config, server, app)

  assert.equal(42, status)
end

-- main fails when active handles persist
function tests.test_fail_active_handles()
  local server = {set_up = function() return 0 end, run = function() return 1 end}
  local config = {host = "127.0.0.1", port = 5555}
  local app = {}

  local status = main.run(config, server, app)

  assert.equal(1, status)
end

-- main loads an app
function tests.test_loads_app()
  local server = {set_up = function() return 0 end, run = function() return false end}
  local config = {host = "127.0.0.1", port = 5555, app = "app.main:app"}

  local status = main.run(config, server)

  assert.equal(0, status)
end

-- main fails when there is no app
function tests.test_no_app()
  local server = {set_up = function() return 0 end, run = function() return false end}
  local config = {host = "127.0.0.1", port = 5555, app = "app.main:app_not_here"}

  local status, message = pcall(main.run, config, server)

  assert.is_false(status)
  assertions.contains("No app named 'app_not_here' found in module 'app.main'", message)
end

return tests

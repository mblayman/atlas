local assert = require "luassert.assert"
local stub = require "luassert.stub"

local Server = require "atlas.server.server"

local function build_mock_server()
  return {bind = function() return 0 end, listen = function() return 0 end}
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
  end)
end)

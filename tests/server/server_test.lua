local Server = require "atlas.server.server"

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
end)

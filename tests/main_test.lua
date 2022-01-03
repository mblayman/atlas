local main = require "atlas.main"

describe("config parser", function()
  it("builds a parser with the command name", function()
    local parser = main.build_parser()

    assert.equal("atlas", parser._name)
  end)

  it("stores the command name in the command key", function()
    local parser = main.build_parser()

    local config = parser:parse({"serve", "hello.world:app"})

    assert.equal("serve", config.command)
  end)

  describe("serve command", function()
    it("requires an app", function()
      local parser = main.build_parser()

      local config = parser:parse({"serve", "hello.world:app"})

      assert.equal("hello.world:app", config.app)
    end)

    it("defaults to localhost", function()
      local parser = main.build_parser()

      local config = parser:parse({"serve", "hello.world:app"})

      assert.equal("127.0.0.1", config.host)
    end)

    it("sets the host option", function()
      local parser = main.build_parser()

      local config = parser:parse({"serve", "hello.world:app", "--host", "0.0.0.0"})

      assert.equal("0.0.0.0", config.host)
    end)

    it("has a default port", function()
      local parser = main.build_parser()

      local config = parser:parse({"serve", "hello.world:app"})

      assert.equal(8000, config.port)
    end)

    it("sets a port number option", function()
      local parser = main.build_parser()

      local config = parser:parse({"serve", "hello.world:app", "--port", "5555"})

      assert.equal(5555, config.port)
    end)
  end)
end)

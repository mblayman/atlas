local assert = require "luassert"
local stub = require "luassert.stub"

local main = require "atlas.main"

local tests = {}

-- config parser builds a parser with the command name
function tests.test_command_name()
  local parser = main.build_parser()

  assert.equal("atlas", parser._name)
end

-- config parser stores the command name in the command key
function tests.test_store_command()
  local parser = main.build_parser()

  local config = parser:parse({"serve", "hello.world:app"})

  assert.equal("serve", config.command)
end

-- config parser serve command requires an app
function tests.test_serve_require_app()
  local parser = main.build_parser()

  local config = parser:parse({"serve", "hello.world:app"})

  assert.equal("hello.world:app", config.app)
end

-- config parser serve command defaults to localhost
function tests.test_default_localhost()
  local parser = main.build_parser()

  local config = parser:parse({"serve", "hello.world:app"})

  assert.equal("127.0.0.1", config.host)
end

-- config parser serve command sets the host option
function tests.test_sets_host()
  local parser = main.build_parser()

  local config = parser:parse({"serve", "hello.world:app", "--host", "0.0.0.0"})

  assert.equal("0.0.0.0", config.host)
end

-- config parser serve command has a default port
function tests.test_default_port()
  local parser = main.build_parser()

  local config = parser:parse({"serve", "hello.world:app"})

  assert.equal(8000, config.port)
end

-- config parser serve command sets a port number option
function tests.test_sets_port()
  local parser = main.build_parser()

  local config = parser:parse({"serve", "hello.world:app", "--port", "5555"})

  assert.equal(5555, config.port)
end

-- execute shows help when no command is provided
function tests.test_show_help()
  local config = {command = nil}
  local parser = {}
  stub(parser, "get_help").returns("")

  local status = main.execute(config, parser)

  assert.stub(parser.get_help).called()
  assert.equal(0, status)
end

-- execute fails when the user config is missing
function tests.test_execute_no_config()
  local config = {command = "serve"}
  local parser = {}
  local user_config_module_path = nil

  local status = main.execute(config, parser, user_config_module_path)

  assert.equal(1, status)
end

return tests

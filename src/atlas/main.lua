local argparse = require "argparse"

local server_main = require "atlas.server.main"

-- The dispatch table of run functions
local command_dispatch = {serve = server_main.run}

-- Add the `serve` command configuration.
local function add_serve(parser)
  local serve = parser:command("serve", "Serve HTTP requests.")
  serve:argument("app",
                 "The ASGI application to run, in the format \"<module>:<attribute>\"")
  serve:option("--host", "Bind socket to this host.", "127.0.0.1")
  serve:option("--port", "Bind socket to this port.", "8000", tonumber)
end

-- Build the interface parser.
local function build_parser()
  local parser = argparse("atlas", "The Atlas web framework")
  parser:add_help_command()
  parser:command_target("command")
  parser:require_command(false)

  add_serve(parser)
  return parser
end

local function execute(config, parser)
  -- TODO: Write tests for this function.
  -- print output messes up the test results so there must be some way to catch
  -- that output.
  -- I bet I can mock the dispatch table with a noop run function.

  -- luacov: disable
  -- The require command true mode is harsh and doesn't tell what subcommands exist.
  -- Check if there is no command and show the help if appropriate.
  local status = 0
  if config.command == nil then
    print(parser:get_help())
  elseif command_dispatch[config.command] then
    status = command_dispatch[config.command](config)
  end

  return status
  -- luacov: enable
end

-- Get this party started.
local function main(args)
  -- All the pieces are testable so don't worry about the integration coverage.
  -- luacov: disable
  local parser = build_parser()
  local config = parser:parse(args)
  local status = execute(config, parser)
  os.exit(status)
  -- luacov: enable
end

return {main = main, build_parser = build_parser}

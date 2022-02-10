local argparse = require "argparse"

local logging = require "atlas.logging"
local server_main = require "atlas.server.main"

local logger = logging.get_logger("atlas.main")

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

-- Execute the command defined in the parser config.
local function execute(config, parser, user_config_module_path)
  local status = 0

  -- The require command true mode is harsh and doesn't tell what subcommands exist.
  -- Check if there is no command and show the help if appropriate.
  if config.command == nil then
    logger.log(parser:get_help(), true)

  else
    -- TODO: The need for a user config should vary by command,
    -- but checking here is fine for now.
    if not user_config_module_path then
      logger.log("The ATLAS_CONFIG environment variable is not set.")
      logger.log("Please set the variable to continue.")
      status = 1
    else
      -- TODO: Write tests for this function.
      -- I bet I can mock the dispatch table with a noop run function.
      -- luacov: disable
      status = command_dispatch[config.command](config)
      -- luacov: enable
    end
  end

  return status
end

-- Get this party started.
local function main(args)
  -- All the pieces are testable so don't worry about the integration coverage.
  -- luacov: disable
  coroutine.wrap(function()
    local parser = build_parser()
    local config = parser:parse(args)
    local status = execute(config, parser, os.getenv("ATLAS_CONFIG"))
    os.exit(status)
  end)()
  -- luacov: enable
end

return {main = main, build_parser = build_parser, execute = execute}

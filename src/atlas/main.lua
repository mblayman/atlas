local argparse = require "argparse"
local inspect = require "inspect"

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
  parser:command_target("command")
  parser:require_command(false)

  add_serve(parser)
  return parser
end

-- Get this party started.
local function main(args)
  -- Skip testing main for now (partly because I don't know how to mock os.exit in Lua).
  -- luacov: disable
  local parser = build_parser()
  local config = parser:parse(args)

  -- The require command true mode is harsh and doesn't tell what subcommands exist.
  -- Check if there is no command and show the help if appropriate.
  if config.command == nil then
    print(parser:get_help())
    os.exit(0)
  end

  print(inspect(config))
  -- luacov: enable
end

return {main = main, build_parser = build_parser}

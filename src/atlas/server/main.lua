local utils = require "pl.utils"

local Server = require "atlas.server.server"

-- Load the app from the configuration.
local function load_app(config)
  local app_module, app_name = utils.splitv(config.app, ":", false, 2)
  local module = require(app_module)
  local app = module[app_name]
  -- TODO: Crash if app is nil.
  return app
end

-- Run the `serve` command.
--
-- server: A dependency injected server for testing modes
-- app: A dependency injected app for testing modes
local function run(config, server, app)
  if app == nil then app = load_app(config) end
  if server == nil then server = Server(app) end

  local status
  status = server:set_up(config)
  if status ~= 0 then return status end

  local has_active_handles = server:run()
  if has_active_handles then status = 1 end
  return status
end

return {run = run}

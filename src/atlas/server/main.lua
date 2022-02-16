local Server = require "atlas.server.server"

-- Run the `serve` command.
--
-- server: A dependency injected server for testing modes
local function run(config, server)
  -- TODO: Find a reasonable way to test this function.
  -- luacov: disable
  if server == nil then server = Server() end

  local status
  status = server:set_up(config)
  if status ~= 0 then return status end

  local has_active_handles = server:run()

  if has_active_handles then status = 1 end
  return status
  -- luacov: enable
end

return {run = run}

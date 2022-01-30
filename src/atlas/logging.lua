local luv = require "luv"

local config = require "atlas.config"

-- Get a logger object configured to log to a particular logging namespace.
--
-- logger: A name for the logger (e.g., "my.module")
local function get_logger(logger)

  -- Log a message to the log file.
  --
  -- The log function is context aware and will write synchronously
  -- if the event loop is not running or operate asynchronously when it is.
  local function log(message)
    if luv.loop_alive() then
      -- TODO: This is not async friendly yet.
      -- Use a combo of uv.fs_write, callbacks, and coroutines.
      config.log_file:write(string.format("%s: %s\n", logger, message))
      config.log_file:flush()
    else
      config.log_file:write(string.format("%s: %s\n", logger, message))
      config.log_file:flush()
    end
  end

  return {log = log}
end

return {get_logger = get_logger}

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
  --
  -- raw: The message should be logged without extra metadata (bool, default: false)
  local function log(message, raw)
    local log_line
    if raw then
      log_line = message
    else
      log_line = string.format("%s: %s\n", logger, message)
    end

    if luv.loop_alive() then
      -- TODO: This is not async friendly yet.
      -- Use a combo of uv.fs_write, callbacks, and coroutines.
      config.log_file:write(log_line)
      config.log_file:flush()
    else
      config.log_file:write(log_line)
      config.log_file:flush()
    end
  end

  return {log = log}
end

return {get_logger = get_logger}

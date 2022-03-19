local luv = require "luv"

local config = require "atlas.config"
local fs = require "atlas.fs"

local logging = {}

-- Get a logger object configured to log to a particular logging namespace.
--
-- logger: A name for the logger (e.g., "my.module")
function logging.get_logger(logger)

  -- Log a message to the log file.
  --
  -- The log function is context aware and will write synchronously
  -- if the event loop is not running or operate asynchronously when it is.
  --
  -- message: The message to add to the log
  -- raw: The message should be logged without extra metadata (bool, default: false)
  local function log(message, raw)
    local log_line
    if raw then
      log_line = message
    else
      log_line = string.format("%s: %s\n", logger, message)
    end

    if luv.loop_alive() then
      fs.write(config.log_file_fd, log_line)
    else
      luv.fs_write(config.log_file_fd, log_line)
    end
  end

  return {log = log}
end

return logging

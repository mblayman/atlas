local config = require "atlas.config"

-- Get a logger object configured to log to a particular logging namespace.
--
-- logger: A name for the logger (e.g., "my.module")
local function get_logger(logger)

  -- Log a message to the log file.
  local function log(message)
    -- TODO: This is not async friendly.
    -- This probably needs to detect if the event loop has started,
    -- then use a combo of uv.fs_write, callbacks, and coroutines.
    config.log_file:write(string.format("%s: %s\n", logger, message))
    config.log_file:flush()
  end

  return {log = log}
end

return {get_logger = get_logger}

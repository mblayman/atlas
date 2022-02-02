-- Atlas configuration
--
-- This is the implementation of the configuration interface
-- and should be considered private API.
--
-- System defaults:
local default_config = {
  -- The log file handle for the logger
  log_file = io.stdout,
}

local Configuration = {}
Configuration.__index = Configuration

local function _init(_, user_config)
  local self = setmetatable({}, Configuration)

  -- Shallow copy the defaults.
  for config_key, config_value in pairs(default_config) do
    self[config_key] = config_value
  end

  self.has_user_config = false
  if user_config then
    -- Merge.
    for user_key, user_value in pairs(user_config) do self[user_key] = user_value end
    self.has_user_config = true
  end

  return self
end
setmetatable(Configuration, {__call = _init})

return Configuration

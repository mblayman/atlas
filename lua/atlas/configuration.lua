-- Atlas configuration
--
-- This is the implementation of the configuration interface
-- and should be considered private API.
local luv = require "luv"

local default_config = require "atlas.default_config"

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

  if self.log_file ~= "" then
    self.log_file_fd = luv.fs_open(self.log_file, "w", 0666)
  else
    self.log_file_fd = 1 -- stdout
  end
  return self
end
setmetatable(Configuration, {__call = _init})

return Configuration

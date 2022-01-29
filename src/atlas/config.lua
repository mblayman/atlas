-- Atlas configuration
local default_config = {
  -- The log file handle for the logger
  log_file = io.stdout,
}

local user_config_module_path = os.getenv("ATLAS_CONFIG")
if not user_config_module_path then os.exit(false) end
local user_config = require(user_config_module_path)

-- Shallow copy the defaults.
local config = {}
for config_key, config_value in pairs(default_config) do
  config[config_key] = config_value
end

-- Merge.
for user_key, user_value in pairs(user_config) do config[user_key] = user_value end

return config

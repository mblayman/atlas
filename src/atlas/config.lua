-- Atlas configuration interface
local Configuration = require "atlas.configuration"

local user_config = nil
local user_config_module_path = os.getenv("ATLAS_CONFIG")
if user_config_module_path then
  -- print("The ATLAS_CONFIG environment variable is not set.")
  -- print("Please set the variable to continue.")
  -- os.exit(false)
  user_config = require(user_config_module_path)
end

local config = Configuration(user_config)

return config

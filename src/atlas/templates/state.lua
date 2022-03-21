-- A container for the runtime template state used by the framework
local config = require "atlas.config"
local Environment = require "atlas.templates.environment"

local state = {}

state.environment = Environment(config.template_dirs)

return state

local FileLoader = require "atlas.templates.file_loader"

local Environment = {}
Environment.__index = Environment

local function _init(_, template_dirs)
  local self = setmetatable({}, Environment)
  self.context = {}

  local loader = FileLoader(template_dirs)
  self.templates = loader:load(self.context)
  return self
end
setmetatable(Environment, {__call = _init})

-- Get a template at the given template path name.
--
-- name: A template path name
function Environment.get_template(self, name) return self.templates[name] end

return Environment

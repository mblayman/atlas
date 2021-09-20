local Template = {}

local function _init(cls, source)
  local self = setmetatable({}, Template)
  self.source = source
  return self
end
setmetatable(Template, {__call = _init})

return Template

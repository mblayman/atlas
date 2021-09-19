local Environment = {}

local function _init(cls)
  local self = setmetatable({}, Environment)
  return self
end
setmetatable(Environment, {__call = _init})

return Environment

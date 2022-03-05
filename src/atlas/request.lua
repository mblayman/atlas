local Request = {}
Request.__index = Request

-- An HTTP request
--
-- The request object is the primary input interface for controllers.
--
-- scope: An ASGI scope with connection information
local function _init(_, scope)
  local self = setmetatable({}, Request)
  self.scope = scope
  return self
end
setmetatable(Request, {__call = _init})

return Request

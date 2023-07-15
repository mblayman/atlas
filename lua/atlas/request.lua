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

  -- Scope proxy attributes
  self.path = self.scope.path

  return self
end
setmetatable(Request, {__call = _init})

return Request

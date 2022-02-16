-- Atlas application
local Application = {}
Application.__index = Application

local function _init(_)
  local self = setmetatable({}, Application)
  return self
end

-- Act as a LASGI callable interface.
function Application.__call(_, _, _) -- scope, receive, send
  return true
end

setmetatable(Application, {__call = _init})

return Application

-- Atlas application
local Application = {}
Application.__index = Application

local function _init(_)
  local self = setmetatable({}, Application)
  return self
end

-- Act as a LASGI callable interface.
function Application.__call(_, _, receive, send) -- scope, receive, send
  local _ = receive() -- event
  send({
    type = "http.response.start",
    status = 200,
    headers = {{"content-type", "text/plain; charset=utf-8"}},
  })
  send({type = "http.response.body", body = "Hello World!"})
  -- TODO: Ditch the return
  return true
end

setmetatable(Application, {__call = _init})

return Application

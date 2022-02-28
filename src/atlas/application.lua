local Router = require "atlas.router"

-- Atlas application
local Application = {}
Application.__index = Application

local function _init(_, routes)
  local self = setmetatable({}, Application)
  self.router = Router(routes)
  return self
end

-- Act as a LASGI callable interface.
function Application.__call(_, _, receive, send) -- scope, receive, send
  -- TODO:
  -- add a router
  -- match, route = router.route(scope["method"], scope["path"])
  -- if match
  -- build request
  -- route:run will parse the path
  -- response = route:run(request)
  -- else 404

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

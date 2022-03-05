local Match = require "atlas.match"
local Request = require "atlas.request"
local Router = require "atlas.router"
local FULL, PARTIAL = Match.FULL, Match.PARTIAL

-- Atlas application
local Application = {}
Application.__index = Application

local function _init(_, routes)
  local self = setmetatable({}, Application)
  self.router = Router(routes)
  return self
end

-- Act as a LASGI callable interface.
function Application.__call(self, scope, receive, send)
  local match, _ = self.router:route(scope.method, scope.path)
  if match == FULL then
    local _ = Request(scope)
    -- route:run will parse the path
    -- response = route:run(request)
    print("it matched")
  elseif match == PARTIAL then
    -- TODO: return 405
    print("partial")
  else
    -- TODO: return 404
    print("none")
  end

  -- TODO: When is this supposed to be called?
  -- What happens on a request with no body?
  local _ = receive() -- event

  -- TODO: This stuff probably belongs in the response.
  send({
    type = "http.response.start",
    status = 200,
    headers = {{"content-type", "text/plain; charset=utf-8"}},
  })
  send({type = "http.response.body", body = "Hello World!"})
end

setmetatable(Application, {__call = _init})

return Application

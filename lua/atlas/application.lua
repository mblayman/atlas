local Match = require "atlas.match"
local Request = require "atlas.request"
local Response = require "atlas.response"
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
  -- TODO: When is this supposed to be called?
  -- What happens on a request with no body?
  local _ = receive() -- event

  local response = Response("Not Found", "text/html", 404)
  local match, route = self.router:route(scope.method, scope.path)
  if match == FULL then
    local request = Request(scope)
    response = route:run(request)
  elseif match == PARTIAL then
    response = Response("Method Not Allowed", "text/html", 405)
  end

  response(send)
end

setmetatable(Application, {__call = _init})

return Application

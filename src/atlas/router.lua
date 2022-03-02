local Match = require "atlas.match"
local NONE = Match.NONE

local Router = {}
Router.__index = Router

-- A collection of ordered routes
--
-- The router is responsible for finding a route that matches a URL path.
--
-- routes: A table of routes to check against
local function _init(_, routes)
  local self = setmetatable({}, Router)
  self.routes = routes
  return self
end
setmetatable(Router, {__call = _init})

function Router.route(self, method, path)
  for _, route in ipairs(self.routes) do
    local match = route:matches(method, path)
    if match ~= NONE then return match, route end
  end
  return NONE, nil
end

return Router

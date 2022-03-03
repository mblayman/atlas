local Match = require "atlas.match"
local FULL, PARTIAL = Match.FULL, Match.PARTIAL

local Route = {}
Route.__index = Route

-- A route to an individual controller
--
-- A route is used to connect an incoming request to the responsible controller.
--
-- path: A path template
-- controller: A controller function
-- methods: A table of methods that the controller can handle (default: {"GET"})
local function _init(_, path, controller, methods)
  local self = setmetatable({}, Route)

  self.path = path
  self.controller = controller

  if not methods then
    self.methods = {"GET"}
  else
    self.methods = methods
  end

  return self
end
setmetatable(Route, {__call = _init})

function Route.matches(self, method, _) -- self, method, path
  -- TODO: match path against a generated pattern

  for _, allowed_method in ipairs(self.methods) do
    if method == allowed_method then return FULL end
  end
  return PARTIAL
end

return Route

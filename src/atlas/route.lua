local Match = require "atlas.match"
local FULL, NONE, PARTIAL = Match.FULL, Match.NONE, Match.PARTIAL

-- Make a pattern that matches the path template.
local function make_path_matcher(path)
  -- TODO: convert the path
  -- TODO: assert that the converter is valid.
  return path .. "$"
end

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
  self.path_pattern = make_path_matcher(path)
  self.controller = controller

  if not methods then
    self.methods = {"GET"}
  else
    self.methods = methods
  end

  return self
end
setmetatable(Route, {__call = _init})

-- Check if the route matches the method and path.
--
-- The match has three states:
-- * NONE - no match
-- * PARTIAL - the path matches, but the method is not allowed
-- * FULL - the path matches and the method is allowed
--
-- method: An HTTP method, uppercased
-- path: An HTTP request path
function Route.matches(self, method, path)
  if not string.match(path, self.path_pattern) then return NONE end

  for _, allowed_method in ipairs(self.methods) do
    if method == allowed_method then return FULL end
  end
  return PARTIAL
end

return Route

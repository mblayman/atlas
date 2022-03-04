local stringx = require "pl.stringx"

local Match = require "atlas.match"
local FULL, NONE, PARTIAL = Match.FULL, Match.NONE, Match.PARTIAL

-- Converter is not optional!
local PARAMETER_PATTERN = "{([a-zA-Z_][a-zA-Z0-9_]*)(:[a-zA-Z_][a-zA-Z0-9_]*)}"

local CONVERTER_PATTERNS = {
  -- string should include any character except a slash.
  string = "([^/]*)",
  int = "([%d]*)",
}

-- Make a pattern that matches the path template.
local function make_path_matcher(path)
  assert(stringx.startswith(path, "/"), "A route path must start with a slash `/`.")

  local pattern = ""
  local index, path_length = 1, string.len(path)
  local parameter_start, parameter_end
  while index <= path_length do
    parameter_start, parameter_end = string.find(path, PARAMETER_PATTERN, index)
    if parameter_start then
      -- Include any literal characters before the parameter.
      pattern = pattern .. string.sub(path, index, parameter_start - 1)

      local _, converter = string.match(path, PARAMETER_PATTERN, parameter_start)
      local converter_type = string.sub(converter, 2) -- strip off the colon
      local converter_pattern = CONVERTER_PATTERNS[converter_type]

      pattern = pattern .. converter_pattern
      index = parameter_end + 1
    else
      -- No parameters. Capture any remaining portion.
      pattern = pattern .. string.sub(path, index)
      break
    end
  end
  return pattern .. "$"
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

local assert = require "luassert.assert"

local Route = require "atlas.route"
local Match = require "atlas.match"
local FULL = Match.FULL

describe("Route", function()

  it("constructs an instance", function()
    local controller = function() end
    local route = Route("/", controller, {"GET", "POST"})

    assert.equal(getmetatable(route), Route)
    assert.same("/", route.path)
    assert.equal(controller, route.controller)
    assert.same({"GET", "POST"}, route.methods)
  end)

  it("defaults a methods table", function()
    local controller = function() end
    local route = Route("/", controller)

    assert.same({"GET"}, route.methods)
  end)

  it("matches fully", function()
    local controller = function() end
    local route = Route("/", controller)

    local match = route:matches("GET", "/")

    assert.same(FULL, match)
  end)

  it("tests #xfail", function()
    local path = "/{username:string}"
    -- Converter is not optional!
    local pattern = "{([a-zA-Z_][a-zA-Z0-9_]*)(:[a-zA-Z_][a-zA-Z0-9_]*)}"

    for parameter, converter in string.gmatch(path, pattern) do
      print(parameter)
      print(converter)
    end

    assert.is_nil(true)
  end)
end)

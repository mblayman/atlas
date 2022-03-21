local assert = require "luassert.assert"

local Request = require "atlas.request"
local templates = require "atlas.templates"
local assertions = require "atlas.test.assertions"

describe("render", function()

  it("generates a response", function()
    local request = Request({})
    local context = {}

    local response = templates.render(request, "dir1/a.html", context)

    assert.equal("I am a template.\n", response.content)
  end)

  it("errors with an unknown template", function()
    local request = Request({})
    local context = {}

    local status, message = pcall(templates.render, request, "nope.html", context)

    assert.is_false(status)
    assertions.contains("Template not found: nope.html", message)
  end)
end)

local assert = require "luassert"

local Request = require "atlas.request"
local templates = require "atlas.templates"
local assertions = require "atlas.test.assertions"

local tests = {}

-- render generates a response
function tests.test_render()
  local request = Request({})
  local context = {}

  local response = templates.render(request, "dir1/a.html", context)

  assert.equal("I am a template.\n", response.content)
end

-- render errors with an unknown template
function tests.test_render_unknown_template()
  local request = Request({})
  local context = {}

  local status, message = pcall(templates.render, request, "nope.html", context)

  assert.is_false(status)
  assertions.contains("Template not found: nope.html", message)
end

return tests

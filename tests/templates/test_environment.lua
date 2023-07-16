local assert = require "luassert"
local path = require "pl.path"

local Environment = require "atlas.templates.environment"

local test_path = path.package_path("tests.templates.file_loader_test")
local templates_test_path = path.dirname(path.abspath(test_path))

local tests = {}

-- Environment constructs an instance
function tests.test_constructor()
  local template_dirs = {}
  local environment = Environment(template_dirs)

  assert.equal(Environment, getmetatable(environment))
  assert.is_not_nil(environment.context)
  assert.is_not_nil(environment.templates)
end

-- Environment gets a template
function tests.test_get_template()
  local dir1 = path.join(templates_test_path, "static", "dir1")
  local template_dirs = {dir1}
  local environment = Environment(template_dirs)

  local template = environment:get_template("a.html")

  assert.is_not_nil(template)
end

return tests

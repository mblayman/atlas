local assert = require "luassert.assert"
local path = require "pl.path"

local Environment = require "atlas.templates.environment"

local test_path = path.package_path("tests.templates.file_loader_test")
local templates_test_path = path.dirname(path.abspath(test_path))

describe("Environment", function()

  it("constructs an instance", function()
    local template_dirs = {}
    local environment = Environment(template_dirs)

    assert.equal(Environment, getmetatable(environment))
    assert.is_not_nil(environment.context)
    assert.is_not_nil(environment.templates)
  end)

  it("gets a template", function()
    local dir1 = path.join(templates_test_path, "static", "dir1")
    local template_dirs = {dir1}
    local environment = Environment(template_dirs)

    local template = environment:get_template("a.html")

    assert.is_not_nil(template)
  end)
end)

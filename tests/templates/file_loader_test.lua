local assert = require "luassert.assert"
local path = require "pl.path"
local tablex = require "pl.tablex"

local FileLoader = require "atlas.templates.file_loader"
local assertions = require "atlas.test.assertions"

local test_path = path.package_path("tests.templates.file_loader_test")
local templates_test_path = path.dirname(path.abspath(test_path))

describe("FileLoader", function()

  it("constructs an instance", function()
    local template_dirs = {}
    local file_loader = FileLoader(template_dirs)

    assert.equal(FileLoader, getmetatable(file_loader))
    assert.equal(template_dirs, file_loader.template_dirs)
  end)

  it("loads templates", function()
    local static_dir = path.join(templates_test_path, "static")
    local template_dirs = {static_dir}
    local file_loader = FileLoader(template_dirs)
    local context = {}

    local templates = file_loader:load(context)

    assert.equal(2, tablex.size(templates))
    assert.is_not_nil(templates["dir1/a.html"])
    assert.is_not_nil(templates["dir2/b.html"])
  end)

  it("loads templates from multiple directories", function()
    local dir1 = path.join(templates_test_path, "static", "dir1")
    local dir2 = path.join(templates_test_path, "static", "dir2")
    local template_dirs = {dir1, dir2}
    local file_loader = FileLoader(template_dirs)
    local context = {}

    local templates = file_loader:load(context)

    assert.equal(2, tablex.size(templates))
    assert.is_not_nil(templates["a.html"])
    assert.is_not_nil(templates["b.html"])
  end)

  it("creates a template with global context", function()
    local dir1 = path.join(templates_test_path, "static", "dir1")
    local template_dirs = {dir1}
    local file_loader = FileLoader(template_dirs)
    local context = {}

    local templates = file_loader:load(context)

    assert.equal(context, templates["a.html"]._context)
  end)

  it("errors when a template directory does not exist", function()
    local template_dirs = {"not/a/directory"}
    local file_loader = FileLoader(template_dirs)
    local context = {}

    local status, message = pcall(file_loader.load, file_loader, context)

    assert.is_false(status)
    assertions.contains("Template directory does not exist: not/a/directory", message)
  end)

end)

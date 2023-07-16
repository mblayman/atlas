local assert = require "luassert"
local path = require "pl.path"
local tablex = require "pl.tablex"

local FileLoader = require "atlas.templates.file_loader"
local assertions = require "atlas.test.assertions"

local test_path = path.package_path("tests.templates.test_file_loader")
local templates_test_path = path.dirname(path.abspath(test_path))

local tests = {}

-- FileLoader constructs an instance
function tests.test_constructor()
  local template_dirs = {}
  local file_loader = FileLoader(template_dirs)

  assert.equal(FileLoader, getmetatable(file_loader))
  assert.equal(template_dirs, file_loader.template_dirs)
end

-- FileLoader loads templates
function tests.test_load()
  local static_dir = path.join(templates_test_path, "static")
  local template_dirs = {static_dir}
  local file_loader = FileLoader(template_dirs)
  local context = {}

  local templates = file_loader:load(context)

  assert.equal(2, tablex.size(templates))
  assert.is_not_nil(templates["dir1/a.html"])
  assert.is_not_nil(templates["dir2/b.html"])
end

-- FileLoader loads templates from multiple directories
function tests.test_load_multiple_dirs()
  local dir1 = path.join(templates_test_path, "static", "dir1")
  local dir2 = path.join(templates_test_path, "static", "dir2")
  local template_dirs = {dir1, dir2}
  local file_loader = FileLoader(template_dirs)
  local context = {}

  local templates = file_loader:load(context)

  assert.equal(2, tablex.size(templates))
  assert.is_not_nil(templates["a.html"])
  assert.is_not_nil(templates["b.html"])
end

-- FileLoader creates a template with global context
function tests.test_global_context()
  local dir1 = path.join(templates_test_path, "static", "dir1")
  local template_dirs = {dir1}
  local file_loader = FileLoader(template_dirs)
  local context = {}

  local templates = file_loader:load(context)

  assert.equal(context, templates["a.html"]._context)
end

-- FileLoader errors when a template directory does not exist
function tests.test_template_directory_error()
  local template_dirs = {"not/a/directory"}
  local file_loader = FileLoader(template_dirs)
  local context = {}

  local status, message = pcall(file_loader.load, file_loader, context)

  assert.is_false(status)
  assertions.contains("Template directory does not exist: not/a/directory", message)
end

return tests

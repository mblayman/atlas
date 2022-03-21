local dir = require "pl.dir"
local file = require "pl.file"
local path = require "pl.path"

local Template = require "atlas.templates.template"

local FileLoader = {}
FileLoader.__index = FileLoader

-- A template loader that reads templates from the file system
--
-- template_dirs: A table of directories to scan for templates
local function _init(_, template_dirs)
  local self = setmetatable({}, FileLoader)
  self.template_dirs = template_dirs
  return self
end
setmetatable(FileLoader, {__call = _init})

function FileLoader.load(self, context)
  local templates = {}

  for _, template_dir in ipairs(self.template_dirs) do
    if not path.exists(template_dir) then
      error(string.format("Template directory does not exist: %s", template_dir))
    end

    for root, _, files in dir.walk(template_dir) do
      for file_ in files:iter() do
        local template_path = path.join(root, file_)
        local template = Template(file.read(template_path), context)
        template:parse()

        local template_name = path.relpath(template_path, template_dir)
        templates[template_name] = template
      end
    end
  end

  return templates
end

return FileLoader

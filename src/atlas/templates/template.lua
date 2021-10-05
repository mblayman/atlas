local CodeBuilder = require 'atlas.templates.code_builder'
local Parser = require 'atlas.templates.parser'

local Template = {}
Template.__index = Template

local function _init(_, source, context)
  local self = setmetatable({}, Template)

  -- The source string to parse
  self._source = source

  -- A context of globals to be accessible to the renderer
  self._context = context

  self._renderer = nil

  return self
end
setmetatable(Template, {__call = _init})

-- Render the template with the provided context table.
--
-- This method assumes that the template is parsed.
function Template.render(self, context)
  -- TODO: Render with self._context and context merged
  return self._renderer(context)
end

-- Parse the source template to produce a renderer function.
function Template.parse(self)
  local parser = Parser()
  local ast = parser:parse(self._source)
  local builder = CodeBuilder()
  self._renderer = builder:build(ast)
  -- Make the method chainable for slightly cleaner test code.
  return self
end

return Template

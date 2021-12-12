local inspect = require "inspect"

local CodeBuilder = require "atlas.templates.code_builder"
local Parser = require "atlas.templates.parser"

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

  if os.getenv("TEMPLATE_AST_DEBUG") then
    -- luacov: disable
    print(inspect(ast))
    -- luacov: enable
  end

  self._renderer = self:_build(ast)

  -- Make the method chainable for slightly cleaner test code.
  return self
end

-- Build the renderer function.
function Template._build(self, ast)
  local builder = CodeBuilder()
  self:_build_header(builder)
  self:_visit_ast(ast, builder)
  self:_build_footer(builder)
  return builder:build()
end

function Template._build_header(_, builder)
  -- Local variables for fast access.
  builder:add_line("local insert = table.insert")
  builder:add_line("")

  -- Start the renderer function.
  builder:add_line("return function (context)")
  builder:indent()
  builder:add_line("-- The output is included in result and concatentated at the end.")
  builder:add_line("local result = {}")
  builder:add_line("")
  builder:add_line("-- The AST parsed body starts here:")
  builder:add_line("")
end

function Template._build_footer(_, builder)
  builder:add_line("")
  builder:add_line("-- The AST parsed body ends above.")
  builder:add_line("")
  builder:add_line("return table.concat(result)")
  builder:dedent()
  builder:add_line("end")
end

-- Walk the AST to build the body of the renderer function.
function Template._visit_ast(self, ast, builder)
  for _, node in ipairs(ast) do self:_visit_node(node, builder) end
end

-- Dispatch to different node types.
function Template._visit_node(self, node, builder)
  if node.node_type == "text" then
    self:_visit_text_node(node, builder)
  elseif node.node_type == "symbol" then
    self:_visit_symbol_node(node, builder)
  elseif node.node_type == "numeral" then
    self:_visit_numeral_node(node, builder)
  end
end

-- Add a symbol to renderer result.
function Template._visit_symbol_node(_, node, builder)
  builder:add_line("insert(result, \"" .. node.symbol .. "\")")
end

-- Add a numeral to renderer result.
function Template._visit_numeral_node(_, node, builder)
  builder:add_line("insert(result, " .. node.numeral .. ")")
end

-- Add raw text to renderer result.
function Template._visit_text_node(_, node, builder)
  builder:add_line("insert(result, " .. string.format("%q", node.text) .. ")")
end

return Template

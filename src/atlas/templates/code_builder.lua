-- A code builder transforms a template AST into a renderer function.
local CodeBuilder = {}
CodeBuilder.__index = CodeBuilder

local function _init(_)
  local self = setmetatable({}, CodeBuilder)

  -- Control how much space added to the renderer function output.
  self._indent_level = 1

  return self
end
setmetatable(CodeBuilder, {__call = _init})

local renderer_header = [[
local insert = table.insert

return function (context)
  -- The output is included in result and concatentated at the end.
  local result = {}

  -- The AST parsed body starts here:
]]

local renderer_footer = [[

  -- The AST parsed body ends above.

  return table.concat(result)
end]]

-- Build the renderer function.
function CodeBuilder.build(self, ast)
  local renderer_source = {renderer_header}
  self:_visit_ast(ast, renderer_source)
  table.insert(renderer_source, renderer_footer)

  local load_source = table.concat(renderer_source, '\n')
  -- print(load_source)

  local chunk, _ = load(load_source)
  -- The renderer is accessible from running the chunk.
  -- Lua does not return the function directly.
  return chunk()
end

-- Walk the AST to build the body of the renderer function.
function CodeBuilder._visit_ast(self, ast, renderer_source)
  for _, node in ipairs(ast) do
    self:_visit_node(node, renderer_source)
  end
end

-- Dispatch to different node types.
function CodeBuilder._visit_node(self, node, renderer_source)
  if node.node_type == 'text' then
    self:_visit_text_node(node, renderer_source)
  end
end

-- Add raw text to renderer result.
function CodeBuilder._visit_text_node(self, node, renderer_source)
  -- TODO: Some escaping technique will be needed for raw text.
  -- As implemented, a closing ]] will break the renderer function.
  local text = self:_indentation() .. 'insert(result, [[' .. node.text .. ']])'
  table.insert(renderer_source, text)
end

-- Get the appropriate amount of indentation whitespace.
function CodeBuilder._indentation(self)
  return string.rep('  ', self._indent_level)
end

return CodeBuilder

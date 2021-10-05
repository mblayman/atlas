-- A code builder transforms a template AST into a renderer function.
local CodeBuilder = {}
CodeBuilder.__index = CodeBuilder

local function _init(_)
  local self = setmetatable({}, CodeBuilder)

  return self
end
setmetatable(CodeBuilder, {__call = _init})

-- Build the renderer function.
function CodeBuilder.build(_, _) -- self, ast
  -- TODO: Build the real renderer
  return function(_)
    return 'hello'
  end
end

return CodeBuilder

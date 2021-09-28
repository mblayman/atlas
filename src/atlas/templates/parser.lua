local Parser = {}
Parser.__index = Parser

local function _init(_)
  local self = setmetatable({}, Parser)
  return self
end
setmetatable(Parser, {__call = _init})

-- Parse the source template into an AST.
function Parser.parse(_, source)
  -- return grammar:match(source)
  return {source}
end

return Parser

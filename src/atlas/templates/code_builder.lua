-- A code builder accepts code strings to build a compiled chunk.
local CodeBuilder = {}
CodeBuilder.__index = CodeBuilder

local function _init(_, indent_level)
  local self = setmetatable({}, CodeBuilder)

  self._code = {}

  -- Control how much space added to the renderer function output.
  if indent_level then
    -- TODO: use indent_level
    -- luacov: disable
    self._indent_level = indent_level
    -- luacov: enable
  else
    self._indent_level = 0
  end

  return self
end

setmetatable(CodeBuilder, {__call = _init})

-- Build the code into a compiled chunk.
function CodeBuilder.build(self)
  local load_source = tostring(self)
  if os.getenv('TEMPLATE_RENDERER_DEBUG') then
    -- luacov: disable
    print(load_source)
    -- luacov: enable
  end

  local chunk, _ = load(load_source)
  -- The code is accessible from running the chunk.
  -- Lua does not return the function directly.
  return chunk()
end

-- Get a string representation of the code.
function CodeBuilder.__tostring(self)
  -- TODO: Iterate through _code to call tostring on anything that looks like a builder.
  return table.concat(self._code, '\n')
end

-- Add a line of code to the builder.
function CodeBuilder.add_line(self, line)
  local indented = string.rep('  ', self._indent_level) .. line
  table.insert(self._code, indented)
end

-- Increase the indentation level.
function CodeBuilder.indent(self)
  self._indent_level = self._indent_level + 1
end

-- Decrease the indentation level.
function CodeBuilder.dedent(self)
  self._indent_level = self._indent_level - 1
end

return CodeBuilder

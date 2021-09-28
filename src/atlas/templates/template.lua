local Template = {}
Template.__index = Template

local function _init(_, source)
  local self = setmetatable({}, Template)

  -- The source string to parse
  self._source = source

  return self
end
setmetatable(Template, {__call = _init})

-- Render the template with the provided context table.
function Template.render(_, _)
  -- TODO: Actually render something.
  return 'hello'
end

-- Parse the source template to produce a renderer function.
function Template.parse(self)
  -- TODO: pass off the source to a parser
  -- TODO: build a renderer from the AST produced by the parser
  self._renderer = true
end

return Template

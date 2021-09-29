local lpeg = require 'lpeg'

local _, CaptureToTable, Pattern, Set, Variable =
  lpeg.C, lpeg.Ct, lpeg.P, lpeg.S, lpeg.V

local Parser = {}
Parser.__index = Parser

local function _init(_)
  local self = setmetatable({}, Parser)
  return self
end
setmetatable(Parser, {__call = _init})

-- Grammar notes:
-- Comment     <- '{#' EndComment
-- EndComment  <- '#}' / . EndComment
-- EndOfString <- !.

-- Note: Higher precedence goes at the bottom

-- Node types:
-- root - a list table
-- text - raw text in the template

-- Node constructors

-- Build a raw text node.
local function make_text_node(pattern)
  return pattern / function(text)
    return {node_type = 'text', ['text'] = text}
  end
end

-- Pattern building blocks

-- Any        <- .
-- local Any = Pattern(1)

-- Whitespace <- [ \t\r\n]*
local Whitespace = Set(' \t\r\n') ^ 0


-- Variables for open references within the grammar
local Template = Variable('Template')

local grammar = Pattern({
  Template,
  Template = CaptureToTable(make_text_node(Whitespace)),
})

-- Parse the source template into an AST.
function Parser.parse(_, source)
  return grammar:match(source)
end

return Parser

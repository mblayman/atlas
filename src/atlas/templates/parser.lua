local lpeg = require 'lpeg'

local CaptureToTable, Pattern, Range, Set, Variable =
  lpeg.Ct, lpeg.P, lpeg.R, lpeg.S, lpeg.V

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
-- text - literal text in the template

-- Node constructors

-- Build a literal text node.
local function make_text_node(matched_text)
  return {node_type = 'text', text = matched_text}
end

-- Build an expression node.
local function make_expression_node(matched_expression)
  return {node_type = 'expression', expression = matched_expression}
end

-- Pattern building blocks

-- Any          <- .
local Any = Pattern(1)

-- Digit        <- [0-9]
local Digit = Range('09')

-- Letter       <- [A-Za-z]
local Letter = Range('AZ', 'az')

-- Whitespace   <- [ \t\r\n]*
local Whitespace = Set(' \t\r\n') ^ 0

-- NameStart    <- Letter / '_'
local NameStart = Letter + '_'

-- NameContinue <- NameStart / Digit
local NameContinue = NameStart + Digit

-- TODO: How to demark that the name is *not* reserved?
-- TODO: restore variable Name
-- Name         <- NameStart (NameContinue)* Whitepace
local _ = NameStart * NameContinue^0 * Whitespace

-- Variables for open references within the grammar
local Template = Variable('Template')
local TemplateExpression = Variable('TemplateExpression')
local Expression = Variable('Expression')
local String = Variable('String')
local SingleQuoted = Variable('SingleQuoted')
local LiteralText = Variable('LiteralText')

local grammar = CaptureToTable(Pattern({
  Template,

  -- Template              <- (TemplateExpression / LiteralText)*
  Template = (TemplateExpression + LiteralText)^0,

  -- TemplateExpression    <- '{{' Whitespace Expression Whitespace '}}'
  TemplateExpression = '{{' * Whitespace * Expression * Whitespace * '}}',

  -- Expression            <- !'}}' String
  Expression = (String - Pattern('}}'))^1 / make_expression_node,

  -- TODO: double quoted
  -- TODO: Are single and double going to fail with newlines?
  -- TODO: long comment
  -- TODO: output string into rendered version
  -- String                <- SingleQuoted / DoubleQuoted
  String = SingleQuoted,

  -- SingleQuoted          <- ['] (!['] .)* ['] Whitespace
  SingleQuoted = "'" * (Any - Pattern("'"))^1 * "'" * Whitespace,

  -- LiteralText           <- !'{{' .*
  LiteralText = (Any - Pattern('{{'))^1 / make_text_node,
}))

-- Parse the source template into an AST.
function Parser.parse(_, source)
  return grammar:match(source)
end

return Parser

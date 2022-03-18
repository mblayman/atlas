--  HTTP-message   = start-line
--                   *( header-field CRLF )
--                   CRLF
--                   [ message-body ]
--
--  start-line     = request-line / status-line
--
--  request-line   = method SP request-target SP HTTP-version CRLF
--
--  Recipients of an invalid request-line SHOULD respond with either a 400 (Bad Request) error
--
--  request-target too long, response with 414 URI Too Long
--
--  > Various ad hoc limitations on request-line length are found in practice.
--  > It is RECOMMENDED that all HTTP senders and recipients support, at a minimum,
--  > request-line lengths of 8000 octets.
local ParserErrors = require "atlas.server.parser_errors"

local Parser = {}
Parser.__index = Parser

local REQUEST_LINE_PATTERN = "^(%u+) ([^ ]+)"

local SUPPORTED_METHODS = {"GET", "POST", "HEAD", "DELETE", "PUT", "PATCH"}
-- Currrently unsupported: CONNECT, OPTIONS, TRACE
-- PATCH is defined in RFC 5789

-- An HTTP 1.1 parser
--
-- This parser focuses on HTTP *request* parsing.
local function _init(_)
  local self = setmetatable({}, Parser)
  return self
end
setmetatable(Parser, {__call = _init})

-- Parse the request data.
--
-- data: Raw network data
--
-- Returns:
-- meta: The non-body portion of the request (a strict subset of an ASGI scope)
-- body: The body data
-- err: Non-nil if an error exists
function Parser.parse(_, data) -- self, data
  local meta = {type = "http"}
  local method, target, _ = string.match(data, REQUEST_LINE_PATTERN) -- version
  if not method then return nil, nil, ParserErrors.INVALID_REQUEST_LINE end

  meta.method = method
  local method_is_supported = false
  for _, supported_method in ipairs(SUPPORTED_METHODS) do
    if method == supported_method then
      method_is_supported = true
      break
    end
  end
  if not method_is_supported then return meta, nil, ParserErrors.METHOD_NOT_IMPLEMENTED end

  meta.path = target
  meta.raw_path = target
  return meta, nil, nil
end

return Parser

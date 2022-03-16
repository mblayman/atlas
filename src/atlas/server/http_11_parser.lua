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
local Parser = {}
Parser.__index = Parser

local REQUEST_LINE_PATTERN = "^(%u+) ([^ ]+)"

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
function Parser.parse(data)
  local meta = {type = "http"}
  local method, target, _ = string.match(data, REQUEST_LINE_PATTERN) -- version
  -- TODO: check if method is nil for no match
  -- TODO: check if method is supported

  meta.method = method
  meta.raw_path = target -- This is only kinda right. Querystring could be in here.
  return meta, nil, nil
end

return Parser

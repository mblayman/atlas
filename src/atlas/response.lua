local Response = {}
Response.__index = Response

-- An HTTP response
--
-- The response object is the primary output interface for controllers.
--
-- content: The content to return over the wire (default: "")
-- content_type: The type of content data (default: "text/html")
-- status_code: The status code (default: 200)
-- headers: HTTP headers (default: {})
local function _init(_, content, content_type, status_code, headers)
  local self = setmetatable({}, Response)

  if content then
    self.content = content
  else
    self.content = ""
  end

  if content_type then
    self.content_type = content_type
  else
    self.content_type = "text/html"
  end

  if status_code then
    self.status_code = status_code
  else
    self.status_code = 200
  end

  if headers then
    self.headers = headers
  else
    self.headers = {}
  end

  return self
end
setmetatable(Response, {__call = _init})

-- Send the response data over the ASGI interface
--
-- send: The ASGI send callable
function Response.__call(self, send)
  local asgi_headers = {}
  for header, value in pairs(self.headers) do
    table.insert(asgi_headers, {string.lower(header), value})
  end

  -- TODO: set the content type header.

  send({
    type = "http.response.start",
    status = self.status_code,
    -- headers = {{"content-type", "text/plain; charset=utf-8"}},
    headers = asgi_headers,
  })
  send({type = "http.response.body", body = self.content})
end

return Response

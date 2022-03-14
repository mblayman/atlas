-- A map of numeric status codes to string representations
return {
  -- 1xx - https://httpwg.org/specs/rfc7231.html#status.1xx
  [100] = "100 Continue",
  [101] = "101 Switching Protocols",
  -- 2xx - https://httpwg.org/specs/rfc7231.html#status.2xx
  [200] = "200 OK",
  [201] = "201 Created",
  [202] = "202 Accepted",
  [203] = "203 Non-Authoritative Information",
  [204] = "204 No Content",
  [205] = "205 Reset Content",
  [206] = "206 Partial Content", -- RFC7233
  -- 3xx - https://httpwg.org/specs/rfc7231.html#status.3xx
  [300] = "300 Multiple Choices",
  [301] = "301 Moved Permanently",
  [302] = "302 Found",
  [303] = "303 See Other",
  [304] = "304 Not Modified", -- RFC7232
  [305] = "305 Use Proxy",
  [306] = "306 (Unused)",
  [307] = "307 Temporary Redirect",
  -- 4xx - https://httpwg.org/specs/rfc7231.html#status.4xx
  [400] = "400 Bad Request",
  [401] = "401 Unauthorized", -- RFC7235
  [402] = "402 Payment Required",
  [403] = "403 Forbidden",
  [404] = "404 Not Found",
  [405] = "405 Method Not Allowed",
  [406] = "406 Not Acceptable",
  [407] = "407 Proxy Authentication Required", -- RFC7235
  [408] = "408 Request Timeout",
  [409] = "409 Conflict",
  [410] = "410 Gone",
  [411] = "411 Length Required",
  [412] = "412 Precondition Failed", -- RFC7232
  [413] = "413 Payload Too Large",
  [414] = "414 URI Too Long",
  [415] = "415 Unsupported Media Type",
  [416] = "416 Range Not Satisfiable", -- RFC7233
  [417] = "417 Expectation Failed",
  [426] = "426 Upgrade Required",
  -- 5xx - https://httpwg.org/specs/rfc7231.html#status.5xx
  [500] = "500 Internal Server Error",
  [501] = "501 Not Implemented",
  [502] = "502 Bad Gateway",
  [503] = "503 Service Unavailable",
  [504] = "504 Gateway Timeout",
  [505] = "505 HTTP Version Not Supported",
}

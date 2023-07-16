local assert = require "luassert"

local Parser = require "atlas.server.http_11_parser"
local ParserErrors = require "atlas.server.parser_errors"

local tests = {}

-- Parser constructs an instance
function tests.test_constructor()
  local parser = Parser()

  assert.equal(getmetatable(parser), Parser)
end

-- Parser parses the method
function tests.test_parses_method()
  local data = "GET / HTTP/1.1\r\n\r\n"
  local parser = Parser()

  local meta = parser:parse(data)

  assert.same("GET", meta.method)
end

-- Parser errors with an invalid request line
function tests.test_invalid_line()
  local data = "INVALID\r\n\r\n"
  local parser = Parser()

  local _, _, err = parser:parse(data)

  assert.same(ParserErrors.INVALID_REQUEST_LINE, err)
end

-- Parser errors with an unsupported method
function tests.test_unsupported_method()
  local data = "INVALID / HTTP/1.1\r\n\r\n"
  local parser = Parser()

  local meta, _, err = parser:parse(data)

  assert.same("INVALID", meta.method)
  assert.same(ParserErrors.METHOD_NOT_IMPLEMENTED, err)
end

-- Parser parses the path
function tests.test_parses_path()
  local data = "GET /some/path HTTP/1.1\r\n\r\n"
  local parser = Parser()

  local meta = parser:parse(data)

  assert.same("/some/path", meta.path)
end

-- Parser parses the raw path
function tests.test_parses_raw_path()
  local data = "GET /some/path HTTP/1.1\r\n\r\n"
  local parser = Parser()

  local meta = parser:parse(data)

  assert.same("/some/path", meta.raw_path)
end

-- Parser parses the version
function tests.test_parses_version()
  local data = "GET / HTTP/1.1\r\n\r\n"
  local parser = Parser()

  local meta = parser:parse(data)

  assert.same("1.1", meta.http_version)
end

-- Parser errors with an unsupported version
function tests.test_unsupported_version()
  local data = "GET / HTTP/99\r\n\r\n"
  local parser = Parser()

  local meta, _, err = parser:parse(data)

  assert.same("99", meta.http_version)
  assert.same(ParserErrors.VERSION_NOT_SUPPORTED, err)
end

return tests

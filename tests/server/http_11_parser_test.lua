local assert = require "luassert.assert"

local Parser = require "atlas.server.http_11_parser"
local ParserErrors = require "atlas.server.parser_errors"

describe("Parser", function()

  it("constructs an instance", function()
    local parser = Parser()

    assert.equal(getmetatable(parser), Parser)
  end)

  it("parses the method", function()
    local data = "GET / HTTP/1.1\r\n\r\n"
    local parser = Parser()

    local meta = parser:parse(data)

    assert.same("GET", meta.method)
  end)

  it("parses the raw path", function()
    local data = "GET / HTTP/1.1\r\n\r\n"
    local parser = Parser()

    local meta = parser:parse(data)

    assert.same("/", meta.raw_path)
  end)

  it("errors with an invalid request line", function()
    local data = "INVALID\r\n\r\n"
    local parser = Parser()

    local _, _, err = parser:parse(data)

    assert.same(ParserErrors.INVALID_REQUEST_LINE, err)
  end)

  it("errors with an unsupported method", function()
    local data = "INVALID / HTTP/1.1\r\n\r\n"
    local parser = Parser()

    local meta, _, err = parser:parse(data)

    assert.same("INVALID", meta.method)
    assert.same(ParserErrors.METHOD_NOT_IMPLEMENTED, err)
  end)

  it("parses the path", function()
    local data = "GET /some/path HTTP/1.1\r\n\r\n"
    local parser = Parser()

    local meta = parser:parse(data)

    assert.same("/some/path", meta.path)
  end)

  it("parses the raw path", function()
    local data = "GET /some/path HTTP/1.1\r\n\r\n"
    local parser = Parser()

    local meta = parser:parse(data)

    assert.same("/some/path", meta.raw_path)
  end)

  it("parses the version", function()
    local data = "GET / HTTP/1.1\r\n\r\n"
    local parser = Parser()

    local meta = parser:parse(data)

    assert.same("1.1", meta.http_version)
  end)

  it("errors with an unsupported version", function()
    local data = "GET / HTTP/99\r\n\r\n"
    local parser = Parser()

    local meta, _, err = parser:parse(data)

    assert.same("99", meta.http_version)
    assert.same(ParserErrors.VERSION_NOT_SUPPORTED, err)
  end)
end)

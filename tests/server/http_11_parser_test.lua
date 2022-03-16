local assert = require "luassert.assert"

local Parser = require "atlas.server.http_11_parser"

describe("Parser", function()

  it("constructs an instance", function()
    local parser = Parser()

    assert.equal(getmetatable(parser), Parser)
  end)

  it("parses the method", function()
    local data = "GET / HTTP/1.1\r\n\r\n"
    local parser = Parser()

    local meta = parser.parse(data)

    assert.same("GET", meta.method)
  end)

  it("parses the raw path", function()
    local data = "GET / HTTP/1.1\r\n\r\n"
    local parser = Parser()

    local meta = parser.parse(data)

    assert.same("/", meta.raw_path)
  end)

end)

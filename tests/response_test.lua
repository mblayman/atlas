local assert = require "luassert.assert"
local spy = require "luassert.spy"

local Response = require "atlas.response"

describe("Response", function()

  it("constructs an instance with defaults", function()
    local response = Response()

    assert.equal(getmetatable(response), Response)
    assert.equal("", response.content)
    assert.equal("text/html", response.content_type)
    assert.equal(200, response.status_code)
    assert.same({}, response.headers)
  end)

  it("sets the content", function()
    local content = "hello world"
    local response = Response(content)

    assert.equal(content, response.content)
  end)

  it("sets the content type", function()
    local content_type = "application/json"
    local response = Response("", content_type)

    assert.equal(content_type, response.content_type)
  end)

  it("sets the status code", function()
    local status_code = 404
    local response = Response("", "text/html", status_code)

    assert.equal(status_code, response.status_code)
  end)

  it("sets the headers", function()
    local headers = {}
    local response = Response("", "text/html", 200, headers)

    assert.equal(headers, response.headers)
  end)

  it("sends response data", function()
    local content = "hello world"
    local response = Response(content)
    response.headers = {["x-foo"] = "bar"}
    local send = spy.new(function() end)

    response(send)

    assert.spy(send).called_with({
      type = "http.response.start",
      status = 200,
      headers = {{"x-foo", "bar"}, {"content-type", "text/html"}},
    })
    assert.spy(send).called_with({type = "http.response.body", body = "hello world"})
  end)
end)

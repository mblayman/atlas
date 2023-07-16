local assert = require "luassert"
local spy = require "luassert.spy"

local Response = require "atlas.response"

local tests = {}

-- Response constructs an instance with defaults
function tests.test_constructor()
  local response = Response()

  assert.equal(getmetatable(response), Response)
  assert.equal("", response.content)
  assert.equal("text/html", response.content_type)
  assert.equal(200, response.status_code)
  assert.same({}, response.headers)
end

-- Response sets the content
function tests.test_content()
  local content = "hello world"
  local response = Response(content)

  assert.equal(content, response.content)
end

-- Response sets the content type
function tests.test_content_type()
  local content_type = "application/json"
  local response = Response("", content_type)

  assert.equal(content_type, response.content_type)
end

-- Response sets the status code
function tests.test_status_code()
  local status_code = 404
  local response = Response("", "text/html", status_code)

  assert.equal(status_code, response.status_code)
end

-- Response sets the headers
function tests.test_headers()
  local headers = {}
  local response = Response("", "text/html", 200, headers)

  assert.equal(headers, response.headers)
end

-- Response sends response data
function tests.test_sends_response_data()
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
end

return tests

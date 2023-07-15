local assert = require "luassert"
local luv = require "luv"

local fs = require "atlas.fs"
local loop = require "atlas.test.loop"

local tests = {}

-- File system writes data
function tests.test_writes()
  local filename = "/tmp/test_fs.txt"
  local file_descriptor = luv.fs_open(filename, "w", 438) -- 0666

  loop.run_once(function() fs.write(file_descriptor, "hello") end)

  local file = io.open(filename, "r")
  local content = file:read()
  file:close()
  assert.equal("hello", content)
end

return tests

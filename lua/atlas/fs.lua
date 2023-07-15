--
-- File system access with coroutines
--
local luv = require "luv"

local fs = {}

-- Make a libuv write callback that will resume the coroutine.
local function make_write_callback()
  local thread = coroutine.running()
  return function(err, _)
    assert(not err, err)
    coroutine.resume(thread)
  end
end

-- Write data to the specified file descriptor.
--
-- file_descriptor: A file descriptor assumed to be in a writeable mode
--            data: The data to write to the file
function fs.write(file_descriptor, data)
  -- -1 is the current file offset
  luv.fs_write(file_descriptor, data, -1, make_write_callback())
  return coroutine.yield()
end

return fs

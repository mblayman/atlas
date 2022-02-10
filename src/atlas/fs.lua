local luv = require "luv"

local fs = {}

-- Make a libuv write callback that will resume the coroutine.
local function make_write_callback()
  local thread = coroutine.running()
  return function(err, _)
    -- TODO: better error handling?
    assert(not err, err)
    coroutine.resume(thread)
  end
end

-- Write data to the specified file descriptor.
--
-- The file descriptor is assumed to be in a writeable mode.
function fs.write(file_descriptor, data)
  -- -1 is the current file offset
  luv.fs_write(file_descriptor, data, -1, make_write_callback())
  return coroutine.yield()
end

return fs

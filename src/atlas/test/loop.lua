local assert = require "luassert.assert"
local luv = require "luv"

local loop = {}

-- Run the event loop once.
--
-- func: A function to execute in the loop.
function loop.run_once(func)
  coroutine.wrap(func)()
  local not_done = luv.run("once")
  assert.is_false(not_done)
end

-- Run the event loop until all callbacks are done.
function loop.run_until_done(func)
  coroutine.wrap(func)()
  -- TODO: This should probably have a limit since it's not actually running once.
  local not_done = true
  while not_done do not_done = luv.run("once") end
end

-- Close any unclosed handles.
function loop.close()
  luv.walk(function(handle) if not handle:is_closing() then handle:close() end end)
end

return loop

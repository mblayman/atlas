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

return loop

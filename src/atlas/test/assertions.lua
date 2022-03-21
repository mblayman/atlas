local assert = require "luassert.assert"

local assertions = {}

-- Check that the string value is in the target.
--
--  value: The value to search for
-- target: The string to search in
function assertions.contains(value, target)
  local found = string.find(target, value, 1, true)
  if found then
    assert.is_true(true)
  else
    -- luacov: disable
    assert.is_true(false,
                   string.format("\nValue:\n\n%s\n\nNot in\n\n%s\n\n", value, target))
    -- luacov: enable
  end
end

return assertions

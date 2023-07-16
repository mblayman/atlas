local assert = require "luassert"

local utils = require "atlas.utils"

local tests = {}

-- Utils checks if a value is in a table
function tests.test_in_table()
  assert.is_true(utils.in_table(1, {3, 2, 1}))
  assert.is_false(utils.in_table(99, {3, 2, 1}))
end

return tests

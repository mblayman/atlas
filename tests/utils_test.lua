local assert = require "luassert.assert"

local utils = require "atlas.utils"

describe("Utils", function()

  it("checks if a value is in a table", function()
    assert.is_true(utils.in_table(1, {3, 2, 1}))
    assert.is_false(utils.in_table(99, {3, 2, 1}))
  end)

end)

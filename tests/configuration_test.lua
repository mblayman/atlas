local assert = require "luassert.assert"

local Configuration = require "atlas.configuration"

describe("Configuration", function()
  it("can omit a user config", function()
    local config = Configuration()

    assert.is_false(config.has_user_config)
  end)

  it("has a user config", function()
    local user_config = {}
    local config = Configuration(user_config)

    assert.is_true(config.has_user_config)
  end)

  it("includes defaults", function()
    local config = Configuration()

    assert.truthy(config.log_file)
  end)

  it("includes a user configuration", function()
    local user_config = {value = 42}
    local config = Configuration(user_config)

    assert.same(42, config.value)
  end)
end)

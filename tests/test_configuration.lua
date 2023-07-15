local assert = require "luassert"

local Configuration = require "atlas.configuration"

local tests = {}

-- Configuration can omit a user config
function tests.test_omit_user_config()
  local config = Configuration()

  assert.is_false(config.has_user_config)
end

-- Configuration has a user config
function tests.test_has_user_config()
  local user_config = {}
  local config = Configuration(user_config)

  assert.is_true(config.has_user_config)
end

-- Configuration includes defaults
function tests.test_includes_defaults()
  local config = Configuration()

  assert.same("", config.log_file)
end

-- Configuration includes a user configuration
function tests.test_includes_user_config()
  local user_config = {value = 42}
  local config = Configuration(user_config)

  assert.same(42, config.value)
end

return tests

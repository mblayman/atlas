-- Begrudgingly, the junk drawer of functions in Atlas
--
-- This is for functions that I can't think of a better home for.
-- I don't like the existence of this module.
--
-- This module is NOT a public interface for Atlas apps.
local utils = {}

-- Check if a value is in the table.
--
-- value: The value to scan for
-- t: The table to check against (assumes a list-like structure)
function utils.in_table(value, t)
  for _, t_value in ipairs(t) do if value == t_value then return true end end
  return false
end

return utils

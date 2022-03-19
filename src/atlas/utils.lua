-- Begrudgingly, the junk drawer of functions in Atlas
--
-- This is for functions that I can't think of a better home for.
-- I don't like the existence of this module.
--
--
-- Check if a value is in the table.
--
-- value: The value to scan for
-- t: The table to check against (assumes a list-like structure)
local function in_table(value, t)
  for _, t_value in ipairs(t) do if value == t_value then return true end end
  return false
end

return {in_table = in_table}

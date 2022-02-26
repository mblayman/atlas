-- Mapping of lowercase headers to expected name in HTTP spec.
--
-- ASGI expects headers to be in lowercase so this table is for quick lookups
-- to avoid the string manipulation.
return {["content-type"] = "Content-Type"}

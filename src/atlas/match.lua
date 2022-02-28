-- A route match can vary by degree.
--
-- To avoid unnecessary route parsing, the router can report a partial match,
-- so that the application can respond with a 405 reponse.
--
return {NONE = 0, PARTIAL = 1, FULL = 2}

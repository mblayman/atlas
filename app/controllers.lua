local Response = require "atlas.response"

local function home() return Response("Hello World!") end

return {home = home}

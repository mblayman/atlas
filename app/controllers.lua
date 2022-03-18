local Response = require "atlas.response"

local function home() return Response("Hello World!") end
local function about() return Response("About Us") end

return {home = home, about = about}

local Response = require "atlas.response"

local controllers = {}
function controllers.home() return Response("Hello World!") end
function controllers.about() return Response("About Us") end

return controllers

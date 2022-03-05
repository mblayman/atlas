local Route = require "atlas.route"

local controllers = require "app.controllers"

return {Route("/", controllers.home)}

local Application = require "atlas.application"

local routes = require "app.routes"

local app = Application(routes)

return {app = app}

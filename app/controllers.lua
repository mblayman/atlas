local templates = require "atlas.templates"
local render = templates.render

local controllers = {}
function controllers.home(request) return render(request, "home.html", {}) end
function controllers.about(request) return render(request, "about.html", {}) end

return controllers

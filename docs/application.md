# Application

An `Application` is the main interface
that connects an Atlas site
to the LASGI server.
The Application is a callable
that adheres to LASGI
and tranforms inbound LASGI scopes
to HTTP requests.

These requests are routed to an appropriate controller
by a set of user defined routes.

```lua
-- myapp/main.lua

local Application = require "atlas.application"
local Route = require "atlas.route"

local controllers = require "myapp.controllers"

routes = {
  Route("/", controllers.home),
  Route("/about", controllers.about),
}
app = Application(routes)

return {app = app}
```

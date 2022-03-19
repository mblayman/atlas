# Configuration

Atlas apps are configured
with a Lua module.
Atlas will load app configuration
from a module path
found in the `ATLAS_CONFIG` environment variable.

Atlas will combine the default configuration
with any user defined values.
User defined configuration will override the defaults.
The combined configuration is accessible
via `atlas.config`.

```lua
-- your_module.lua

local config = require "atlas.config"
```

Atlas will not start without a user-supplied configuration module.

## Default Configuration

### Logging

`log_file` - A path to a log file, the default logs to stdout
(default: `""`)

### Server

`backlog_connections` - The maximum number of backend connections
(default: `128`)

local luv = require "luv"

local atlas_config = require "atlas.config"
local logging = require "atlas.logging"
local logger = logging.get_logger("atlas.server")

local Server = {}
Server.__index = Server

local function _init(_)
  local self = setmetatable({}, Server)
  self._server = nil

  return self
end
setmetatable(Server, {__call = _init})

local function on_connection(client)
  client:read_start(function(err, data)
    -- TODO: graceful termination
    assert(not err, err)

    if data then
      client:write([[HTTP/1.1 200 OK
Content-Length: 12
Content-Type: text/plain; charset=utf-8

Hello World!]])
    else
      client:close()
    end
  end)
end

-- Make the underlying TCP server.
--
-- This allows stubbing of the server in tests.
function Server._make_tcp_server(self)
  local err
  self._server, err = luv.new_tcp()
  if err then
    logger.log("Failed to create a TCP server")
    logger.log(err)
    return 1
  end
  return 0
end

-- Bind to host and port.
function Server._bind(self, config)
  local status, err = self._server:bind(config.host, config.port)
  if status ~= 0 then
    logger.log("Failed to bind to host and port")
    logger.log(err)
    return status
  end
  return 0
end

-- Make the listen callback.
function Server._make_listen_callback(self)
  return function(listen_callback_err)
    -- TODO: This is a callback so how is this supposed to clean up properly
    -- if there is an error?
    assert(not listen_callback_err, listen_callback_err)
    local client = luv.new_tcp()
    local _, accept_err = self._server:accept(client)
    assert(not accept_err, accept_err)

    -- TODO: I don't have a good grasp on why a coroutine gets created here.
    -- I think it's because the listen_callback is invoked the event loop
    -- which somehow is happening outside of the main coroutine.
    coroutine.wrap(function() on_connection(client) end)()
  end
end

-- Configure the server to listen for connections.
function Server._listen(self)
  local status, err = self._server:listen(atlas_config.backlog_connections,
                                          self:_make_listen_callback())
  if status ~= 0 then
    logger.log("Failed to listen to incoming connections")
    logger.log(err)
    return status
  end
  return 0
end

-- Set sigint handler.
--
-- Clean up immediately.
-- When the main loop is running in the default usage,
-- SIGINT doesn't respond unless it happens twice.
-- This handler ensures that the clean up happens right away.
function Server._set_sigint(_)
  local signal, err = luv.new_signal()
  if err then
    logger.log("Failed to set signal handler")
    logger.log(err)
    return 1
  end

  local on_sigint = function(_)
    -- TODO: wat. For some reason, the coroutine is not yieldable here.
    -- That prevents the logger from working.
    -- logger.log("Shutting down")
    -- TODO: better cleanup? close existing handlers?
    os.exit(0)
  end
  luv.signal_start(signal, "sigint", on_sigint)

  return 0
end

-- Set up the server to handle requests.
--
-- Return 0 if setup is successful or 1 if it failed.
function Server.set_up(self, config)
  local status
  status = self:_make_tcp_server()
  if status ~= 0 then return status end

  status = self:_bind(config)
  if status ~= 0 then return status end

  logger.log("Listening for requests on http://" .. config.host .. ":" .. config.port)

  status = self:_listen()
  if status ~= 0 then return status end

  status = self:_set_sigint()
  if status ~= 0 then return status end

  return status
end

-- Run the uv loop.
--
-- The loop status of whether there are still active handles or requests is returned.
function Server.run(_) return luv.run() end

return Server

local luv = require "luv"

local atlas_config = require "atlas.config"
local logging = require "atlas.logging"
local Parser = require "atlas.server.http_11_parser"
local ParserErrors = require "atlas.server.parser_errors"
local http_statuses = require "atlas.server.statuses"
local logger = logging.get_logger("atlas.server")

local Server = {}
Server.__index = Server

local function _init(_, app)
  local self = setmetatable({}, Server)
  self._server = nil
  self._app = app

  return self
end
setmetatable(Server, {__call = _init})

local ASGI_VERSION = {version = "3.0", spec_version = "2.3"}

local function on_connection(client, app)
  client:read_start(function(err, data)
    -- TODO: This will be replaced with a real implementation soon,
    -- so don't worry about the coverage of it.
    -- luacov: disable
    assert(not err, err)

    -- TODO: Pass along any request body data.
    local receive = function()
      return {
        type = "http.request",
        body = "",
        -- Don't bother with more_body.
        -- Make the server join the body together rather than pushing
        -- that responsibility to the app.
        more_body = false,
      }
    end

    local response = {}
    local send = function(event)
      if event.type == "http.response.start" then
        response.status = event.status
        response.headers = event.headers
      elseif event.type == "http.response.body" then
        response.body = event.body
      end
    end

    if data then
      local parser = Parser()
      local scope, _, parser_err = parser:parse(data) -- meta, body, parser_err

      if parser_err then
        if parser_err == ParserErrors.INVALID_REQUEST_LINE then
          client:write("HTTP/1.1 400 Bad Request\r\n\r\n")
        elseif parser_err == ParserErrors.METHOD_NOT_IMPLEMENTED then
          client:write("HTTP/1.1 501 Not Implemented\r\n\r\n")
        end
        return
      end

      scope.asgi = ASGI_VERSION
      scope.http_version = "1.1"
      -- Constant until the server supports TLS.
      scope.scheme = "http"
      scope.query_string = ""
      scope.root_path = "" -- Not supporting applications mounted at some subpath
      scope.headers = {}
      scope.client = {"127.0.0.1", 8000}
      scope.server = {"127.0.0.1", 8000}

      app(scope, receive, send)

      local wire_response = {
        "HTTP/1.1 ", http_statuses[response.status], "\r\n",
        "content-length: " .. #response.body .. "\r\n",
      }

      for _, header in ipairs(response.headers) do
        table.insert(wire_response, header[1] .. ": " .. header[2] .. "\r\n")
      end

      table.insert(wire_response, "\r\n")
      table.insert(wire_response, response.body)

      client:write(wire_response)
    else
      client:close()
    end
    -- luacov: enable
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
  return function(err)
    -- TODO: This is a callback so how is this supposed to clean up properly
    -- if there is an error?
    assert(not err, err)
    local client = luv.new_tcp()
    local _, accept_err = self._server:accept(client)
    assert(not accept_err, accept_err)

    -- Each client connection must be in a coroutine so it can yield back
    -- to the main event loop if it has some blocking activity.
    coroutine.wrap(function() on_connection(client, self._app) end)()
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

function Server.on_sigint(_)
  -- TODO: wat. For some reason, the coroutine is not yieldable here.
  -- That prevents the logger from working.
  -- logger.log("Shutting down")
  -- TODO: better cleanup? close existing handlers?
  os.exit(0)
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

  luv.signal_start(signal, "sigint", Server.on_sigint)
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

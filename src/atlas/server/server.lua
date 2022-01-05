local luv = require("luv")

local Server = {}
Server.__index = Server

local function _init(_)
  local self = setmetatable({}, Server)
  self._server = nil

  -- TODO: run_mode to control the mode argument to luv.run

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

-- Set up the server to handle requests.
--
-- Return 0 if setup is successful or 1 if it failed.
function Server.set_up(self, config)
  local tcp_err
  self._server, tcp_err = luv.new_tcp() -- TODO: Should this pass a family flag argument?
  if tcp_err then
    print("Failed to create a TCP server", tcp_err)
    return 1
  end

  local bind_status, bind_err = self._server:bind(config.host, config.port)
  if bind_status ~= 0 then
    print("Failed to bind to host and port", bind_err)
    return 1
  end

  local listen_callback = function(listen_callback_err)
    -- TODO: This is a callback so how is this supposed to clean up properly
    -- if there is an error?
    assert(not listen_callback_err, listen_callback_err)
    local client = luv.new_tcp()
    local _, accept_err = self._server:accept(client)
    assert(not accept_err, accept_err)
    on_connection(client)
  end

  -- TODO: investigate this value. Should it be configurable? What is a good default?
  local backlog_connections = 128
  local listen_status, listen_err = self._server:listen(backlog_connections,
                                                        listen_callback)
  if listen_status ~= 0 then
    print("Failed to listen to incoming connections", listen_err)
    return 1
  end

  -- Clean up immediately.
  -- When the main loop is running in the default usage,
  -- SIGINT doesn't respond unless it happens twice.
  -- This handler ensures that the clean up happens right away.
  local signal, signal_err = luv.new_signal()
  if signal_err then
    print("Failed to set signal handler", signal_err)
    return 1
  end

  local on_sigint = function(_)
    print("\nShutting down")
    -- TODO: better cleanup? close existing handlers?
    os.exit(1)
  end
  luv.signal_start(signal, "sigint", on_sigint)

  return 0
end

-- Run the uv loop.
--
-- The loop status of whether there are still active handles or requests is returned.
function Server.run(_)
  print("Listening for requests")
  return luv.run()
end

return Server

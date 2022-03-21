-- System defaults:
return {
  ----
  -- Logging
  ----

  -- The log file path for the logger
  --
  -- default: "" - logs will go to stdout
  log_file = "",

  ----
  -- Server
  ----

  -- Maximum permitted backlog connections for the server
  --
  -- See https://man7.org/linux/man-pages/man2/listen.2.html for more info.
  backlog_connections = 128,

  ----
  -- Templates
  ----

  -- A table of template directories to scan for templates
  --
  -- default: {}
  template_dirs = {},
}

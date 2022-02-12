-- System defaults:
return {
  -- The log file path for the logger
  --
  -- default: "" - logs will go to stdout
  log_file = "",

  -- Maximum permitted backlog connections for the server
  --
  -- See https://man7.org/linux/man-pages/man2/listen.2.html for more info.
  backlog_connections = 128,
}

local function make_scope()
  return {
    type = "http",
    asgi = {version = "3.0", spec_version = "2.3"},
    http_version = "1.1",
    method = "GET",
    scheme = "http",
    path = "/",
    raw_path = "/",
    query_string = "",
    root_path = "",
    headers = {},
    client = {"127.0.0.1", 8000},
    server = {"127.0.0.1", 8000},
  }
end

return {make_scope = make_scope}

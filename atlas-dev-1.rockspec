package = "atlas"
version = "dev-1"

source = {
  url = "git+ssh://git@github.com/mblayman/atlas.git"
}

description = {
  summary = "A Lua web framework (someday... maybe)",
  detailed = "A Lua web framework (someday... maybe)",
  homepage = "https://github.com/mblayman/atlas",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1, < 5.5",
  "inspect",
  "lpeg",
  "luv",
}

build = {
  type = "builtin",
  modules = {
    ["atlas.main"] = "src/atlas/main.lua",
    ["atlas.templates.code_builder"] = "src/atlas/templates/code_builder.lua",
    ["atlas.templates.environment"] = "src/atlas/templates/environment.lua",
    ["atlas.templates.parser"] = "src/atlas/templates/parser.lua",
    ["atlas.templates.template"] = "src/atlas/templates/template.lua"
  },
  install = {
    bin = {"bin/atlas"}
  },
  copy_directories = {
    "docs",
    "tests"
  }
}

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
}

build = {
   type = "builtin",
   modules = {
      ["atlas.templates.environment"] = "src/atlas/templates/environment.lua",
      ["atlas.templates.template"] = "src/atlas/templates/template.lua"
   },
   copy_directories = {
      "docs",
      "tests"
   }
}

# Atlas

A Lua web framework (someday... maybe)

Atlas is a small moon around Saturn
that was named in 1983, a good year. 😉

Atlas also held up the heavens.
I might be feeling that way
as I get farther into this project.

## What is this project?

This is me wanting to try my hand at something new
and mixing some existing knowledge
that a have, namely, web frameworks.

I'd like to take my knowledge of the features
of a web framework
and see if I can produce one of my own.

I know that Lapis and OpenResty exist.
This project is more for my own exploration
than being a serious entrant
into the web platform arena.

My goal would be to create a lightweight, Django-like framework.

## Where to begin?

I think I want to go down to first principles
for this learning project.
I want to try to build things myself.
I plan to research existing projects,
but I will attempt to write my own versions
of things.
I'm taking this inspiration from Richard Hipp,
the author of SQLite.

There are a number of possible entry points.
This order sounds appealing to me.

* Template engine
* HTTP Server / URL router / Controllers
* DB / ORM
* The rest... 🤓

## Methodology

1. Be guided by tests where possible.
2. Be willing to do my own thing.
3. Re-inventing the wheel may be fun... to a point.

## Tools

* Busted for tests. `luarocks install busted`
* LuaCov for coverage. `luarocks install LuaCov`
* LuaCheck for lint. `luarocks install LuaCheck`
* Here is the pre-commit PR for Lua support:
  https://github.com/pre-commit/pre-commit/pull/2158

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pre-commit install
```

## Release notes

```
luarocks new_version atlas-dev-1.rockspec <new version like 0.2>
# Upload expects branch name of v0.1 format
# Example
luarocks upload rockspecs/atlas-0.1-1.rockspec --api-key=$LUAROCKS_KEY
```

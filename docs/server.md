Server
======

Lua doesn't have anything like Python's WSGI/ASGI protocol.
Because of that, there's no standard server that I can find.
Exploring the field,
I found:

* HAProxy has some Lua support, but it seems fairly limited in scope
  and I'd have to use its libraries and idioms.
  The closest thing I can find to serving requests are applets,
  but they don't seem very popular.
* I briefly looked LWAN, but it's GPLv2. No thanks.
* Lapis uses OpenResty, which is a custom build of Nginx with LuaJIT support.
  This path also feels like I'd be investing into a particular ecosystem's way
  of doing things.
* Lua doesn't have built-in socket support.
  This made me look for primitives that are available.

I considered building into an existing server like Caddy,
but I'm not sure if those kind of servers would keep a Lua process around.
I know that Lua can be embedded and probably controlled from another language,
but my goal is to focus on Lua for fun.

Ultimately, I landed on `libuv`.
I think I could make a server that uses the event loop
and pair with the coroutine features of Lua.
I'm thinking of something like Uvicorn for Lua (Luvicorn?).
I could probably learn a lot by studying that implementation
and how it uses `libuv`.

The `libuv` docs also pointed me to Luvit,
which is a whole little web framework system with a lot of its own tooling.
Frankly, it's somebody's take a web framework, like I'm doing.
He has an 8 year head start.
I'm not sure I like the patterns that I see in the Luvit system
(it's a Lua version of Node.js, according to the author),
but the author did write `luv`,
which appears to be a binding to `libuv` for Lua.
I'm going to try using that.

The implication from my research is that this whole approach pushes me
towards an async web framework.
Having done little async work, I'm in for a lot of learning.

What's next?

* Experiment with `luv` to process network data.
  The experiment is successful when a "Hello World" appears in the browser.
* Study Uvicorn.
 * What if Lua had an ASGI-like interface?
 * What would ASGI look like in Lua that would be different than Python?
* Start an `atlas` binary. `atlas serve` would be a good first command.

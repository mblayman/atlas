# Lua Asynchronous Server Gateway Interface (LASGI)

This project will attempt to adapt Python's ASGI
(https://asgi.readthedocs.io/en/latest/index.html)
into a style appropriate for Lua.

The primary difference between the schemes will be
that ASGI depends on Python's `async`/`await` support
while LASGI will need to rely on Lua's coroutines support.

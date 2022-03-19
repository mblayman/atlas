Design
======

There is a lot to do.
This page is a rough inventory
of what is required
before Atlas would be usable.

* Server
  * [x] Main entry and argument parsing
  * [x] Event loop and incoming connection handling - libuv
  * [x] HTTP parser
  * [x] Translate to ASGI and coroutines
* Framework
  * Required
    * [x] URL routing
    * [x] Controller and core classes like request/response
    * [x] Template engine
    * [ ] ORM
  * Nice to have
    * [x] Logging
    * [ ] Static files
    * [ ] Sessions
    * [ ] Auth
    * [ ] Middleware
* Testing
  * [ ] Mock
  * [ ] Perf (TechEmpower?)

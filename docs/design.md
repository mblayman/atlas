Design
======

There is a lot to do.
This page is a rough inventory
of what is required
before Atlas would be usable.

* Server
  * [x] Main entry and argument parsing
  * [ ] Event loop and incoming connection handling - libuv
  * [ ] HTTP parser
  * [ ] Translate to ASGI and coroutines
* Framework
  * Required
    * [ ] URL routing
    * [ ] Controller and core classes like request/response
    * [ ] Template engine
    * [ ] ORM
  * Nice to have
    * [ ] Logging
    * [ ] Static files
    * [ ] Sessions
    * [ ] Auth
    * [ ] Middleware
* Testing
  * [ ] Mock
  * [ ] Perf (TechEmpower?)

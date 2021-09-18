Templates
=========

Atlas aims to have a template engine similar to Jinja.

* Create an environment.
 * An environment should be able to load template files from a set of directories.
 * Start with searching a single directory.
* Get a template from the environment by relative path name.
 * Templates should be compiled into Lua code, then executed
* Render from the template and pass in a table.
* Autoescape would be a good feature.

Environment
-----------

This is the entry point for fetching a template.

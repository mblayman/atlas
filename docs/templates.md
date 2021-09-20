Templates
=========

Atlas aims to have a template engine similar to Jinja.

* Create an environment.
 * An environment should be able to load template files from a set of directories.
 * Start with searching a single directory.
* Get a template from the environment by relative path name.
 * Templates should be compiled into Lua code, then executed
* Render from the template and pass in a table.

Features
--------

* `if/endif`
* `for/endfor`
* Comments `{# Not in the output. #}`

Extra Desired Features
----------------------

* Autoescape of special characters
* Filters `{{ value|some_filter }}`

Environment
-----------

This is the entry point for fetching a template.

It may be useful for the enviroment to hold a `global` table
that can be passed to templates
as things that are always available.

Template
--------

A template will render context and return a string.

The constructor needs at least two things:

* The template source string to parse
* An initial context that includes the globals
  that will be available to the template.

The template should compile the template into a function
using code generation techniques.
After building up a function string,
the parsing should call `load`
to transform the string into a real executable function.

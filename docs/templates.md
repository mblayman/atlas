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

Jinja syntax: https://jinja.palletsprojects.com/en/3.0.x/templates/

* {% ... %} for Statements
* {{ ... }} for Expressions to print to the template output
* {# ... #} for Comments not included in the template output
* `if/endif`
* `for/endfor`

### Expressions

An expression in Atlas templates take the form of:

```jinja
{{ ... }}
```

Where `...` is an expression that will be evaluated
and the output will be rendered.

Lua has the following grammar for expressions:

```
exp ::=  nil | false | true | Numeral | LiteralString | ‘...’ | functiondef |
         prefixexp | tableconstructor | exp binop exp | unop exp
```

Not every form of an expression makes sense to support in a template engine.
Atlas supports:

| Expression type | Support |
| --- | --- |
| nil | Displays literal 'nil' |
| false | Displays literal 'false' |
| true | Displays literal 'true' |
| Numeral | Displays tostring representation of Numeral. TODO: The representation of a Numeral is pretty complex. How deep should this go? |
| LiteralString | Displays the literal string. |
| '...' | Varargs is not supported. |
| functiondef | Function definition is not supported. |
| prefixexp | TODO: function calls are in here so that needs to be supported. |
| tableconstructor | TODO: support this and display `inspect` output (with a filter)|
| exp binop exp | TODO: support this. |
| unop exp | TODO: support this. |

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

### Development notes

I think the default matching system will not offer enough features
to parse a template adequately.

Lua also doesn't have a regex system.
I've found a couple of paths that I can consider:

1. Use [Lrexlib](https://github.com/rrthomas/lrexlib) and build a lexer and parser.
2. Use [LPeg](http://www.inf.puc-rio.br/~roberto/lpeg/) and write a grammar.
 * Read the [PEG Whitepaper](https://bford.info/pub/lang/peg.pdf)
 * Read the [Packrat Parsing Whitepaper](https://bford.info/pub/lang/packrat-icfp02.pdf)
 * https://stackoverflow.com/questions/56099771/how-to-write-a-simple-peg-grammar-for-a-liquid-like-templating-language
 * http://www.gammon.com.au/lpeg
 * https://docs.python.org/3/library/ast.html
 * https://leafo.net/guides/parsing-expression-grammars.html
 * http://www.playwithlua.com/?p=68
 * http://lua-users.org/wiki/LpegTutorial

LPeg translation to PEG syntax (plus some general notes for better comprehension):

* pattern1 * pattern2 => pattern1 AND pattern2
* pattern1 + pattern2 => pattern1 OR  pattern2 (pattern1 / pattern2 in PEG paper)
* lpeg.R("09")^0      => `\d*` in regex
* lpeg.R("09")^1      => `\d+` in regex
* pattern1 - pattern2 => !pattern2 pattern1

If a pattern matches a whole string, LPeg returns the index after the match.
Translation: len(string) + 1 (remember Lua is 1 indexed!)
E.g., matching "hello" completely would return 6 if there are no captures.

Strategy:

1. Parse the source string into a syntax tree using a PEG grammar.
2. Pass the syntax tree through a code builder (maybe with the visitor pattern)
   to create the renderer function.

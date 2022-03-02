# Routes

An application contains a collection of routes.
The routes are a set of URL patterns
that route incoming HTTP requests
to an appropriate handler function
which Atlas calls a controller.

A route can extract parameters
from the URL
and pass those parameters
to the controller.

A route pattern can look something like:

```text
/users/{username:string}/posts
```

* A route URL pattern starts with `/`
* A route can contain literal text to match (e.g., `/users/`)
* A route parameter reside in curly brackets (i.e., `{}`)
  * The parameter name comes before the `:` (e.g., `username`)
  * A converter that will transform the matched character
    to the associate Lua type.

Available converters:

* `string` - Return the match as a `string` type
* `int` - Return the match as a `number` type passed through `math.tointeger`

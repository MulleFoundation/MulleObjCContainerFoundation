# The MulleObjCFoundation

These are all the classes that run with the standard C libraries only.

* Interfaces with MulleObjC runtime via "ns_foundationconfiguration"
* otherwise it is `mulle_objc_runtime` agnostic, which
means no `mulle_objc` function calls or structure access.


# Why so many little libraries ?

The sub-libraries are there to structure the project. The "Core" libraries
Container, Data, Exception, String, Value are interdependent.

Whereas Locale, KVC, Archiver can be taken out and stuff should still compile.


## Dependencies

MulleObjCFoundation depends on

* MulleObjC
* standard C libraries only (f.e. no `<unistd.h>`)
* mulle_container
* mulle_sprintf
* mulle_utf

MulleObjCFoundation should not depend on ICU, `<unistd.h>` or any POSIX headers.
MulleObjC should not use `mulle_objc_runtime` functions directly, but only
through `MulleObjC`.

# When to release and when to autorelease

* if you are in `-init` or `-dealloc` you `-release`.
* otherwise you **always** `-autorelease` only,

> No rule without exception. If you are sure that the object does not
escape to another object after creation, you may release it within the same
method. (Need to specify what escape means)



# TODO

* KVC doesn't cache yet


## Acknowledgements

Parts of this library:

NSArchiver, NSScanner:

```
/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
```

http_parser:

```
Based on src/http/ngx_http_parse.c from NGINX copyright Igor Sysoev

Additional changes are licensed under the same terms as NGINX and
copyright Joyent, Inc. and other Node contributors. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
```

## Author

[Nat!](//www.mulle-kybernetik.com/weblog) for
[Mulle kybernetiK](//www.mulle-kybernetik.com) and
[Codeon GmbH](//www.codeon.de)

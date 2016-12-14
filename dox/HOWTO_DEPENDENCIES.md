# MulleObjCFoundation does not directly depend on `mulle_objc_runtime`.

* Interfaces with MulleObjC runtime via "ns_foundationconfiguration"
* otherwise it is `mulle_objc_runtime` agnostic, which means no `mulle_objc` 
function calls or structure access.


## Why are there so many little internal libraries ?

The sub-libraries are there to structure the project. The "Core" libraries
Container, Data, Exception, String, Value are interdependent. 

Whereas Locale, KVC, Archiver can be taken out and stuff should still compile.


## Dependencies

MulleObjCFoundation depends on

* [MulleObjC](//github.com/mulle-nat/MulleObjC)
* [mulle_allocator](//github.com/mulle-nat/mulle-allocator)
* [mulle_buffer](//github.com/mulle-nat/mulle-buffer)
* [mulle_container](//github.com/mulle-nat/mulle-container)
* [mulle_sprintf](//github.com/mulle-nat/mulle-sprintf)
* [mulle_utf](//github.com/mulle-nat/mulle-utf)
* standard C libraries (but for example no `<unistd.h>`)

MulleObjCFoundation should not depend on ICU, `<unistd.h>` or any POSIX headers.
MulleObjC should not use `mulle_objc_runtime` functions directly, but only
through `MulleObjC`.


# TODO

* KVC doesn't cache yet


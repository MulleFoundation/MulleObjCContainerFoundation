# The MulleObjCFoundation 

* Interfaces with MulleObJC runtime with "ns_foundationconfiguration"
* otherwise it is <mulle_objc_runtime/mulle_objc_runtime.h> agnostic, which means no _mulle_objc function calls or structure access.

# Why so many little libraries ?

The sublibraries are there to structure the project. The "Core" libraries
Container, Data, Exception, String, Value are interdependent.

Whereas Locale, KVC, Archiver can be taken out and stuff should still compile.


## Dependencies

MulleObjCFoundation depends on 

* MulleObjC
* standard C libraries only (f.e. no <unistd.h>)
* mulle_container 
* mulle_sprintf 
* mulle_utf 

MulleObjCFoundation should not depend on ICU, `<unistd.h>` or any POSIX headers.
MulleObjC should not use mulle_objc_runtime functions directly, but only 
through `MulleObjC`.

# When to release and when to autorelease

* if you are in `-init` or `-dealloc` you `-release`.
* otherwise you **always** `-autorelease` only,

> No rule without exception. If you are sure that the object does not
escape to another object after creation, you may release it within the same 
method. (Need to specify what escape means)



# TODO

* KVC doesn't cache yet
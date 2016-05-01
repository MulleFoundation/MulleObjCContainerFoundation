# The MulleObjCFoundation 

* Interfaces with MulleObJC runtime with "ns_foundationconfiguration"
* otherwise it is <mulle_objc_runtime/mulle_objc_runtime.h> agnostic, which means no _mulle_objc function calls or structure access.

# Why so many little libraries ?

The sublibraries are there to structure the project. The "Core" libraries
Container, Data, Exception, String, Value are interdependent.

Whereas Locale, KVC, Archiver can be taken out and stuff should still compile.


# When to release and when to autorelease

* if you are in `-init` ot `-dealloc` you `-release`.
* otherwise you **always** `-autorelease` only,
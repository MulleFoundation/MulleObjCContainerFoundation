
# When to release and when to autorelease

* if you are in `-init` or `-dealloc` you `-release`.
* otherwise you **always** `-autorelease` only,

> No rule without exception. If you are sure that the object does not
escape to another object after creation, you may release it within the same
method. (Need to specify what escape means)


# Naming and Prefixing

It would be nice if the Foundation would not be using `mulle_objc_...` calls
at all, but have them wrapped into "MulleObjC", but that's just not here
yet.

> Trying to restrict the MulleObjC to just the "MulleObjC" project is foolhardy 
> and confusing:


Prefix       | Description
-------------|----------------
`NS`         | compatible with other runtimes
`_NS`        | private stuff, don't expose. Incompatible variation of NS stuff, try to avoid this and use MulleObjC prefix, except where it's ungainly: ex. `NSCreateHashTable`, `_NSCreateHashTable` is better than `MulleObjCCreateHashTable` (or is it ?)
`MulleObjC`  | use this for public stuff that is incompatible
`_MulleObjC` | private stuff, don't expose 

# Xcode project

The Xcode project is where I develop the library. But the actual build for the
other projects is done with the CMakeLists.txt file. Therefore what is produced
by Xcode is not a valid library, because the headers are intentionally 
incomplete.
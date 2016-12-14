
# When to release and when to autorelease

* if you are in `-init` or `-dealloc` you `-release`.
* otherwise you **always** `-autorelease` only,

> No rule without exception. If you are sure that the object does not
escape to another object after creation, you may release it within the same
method. (Need to specify what escape means)


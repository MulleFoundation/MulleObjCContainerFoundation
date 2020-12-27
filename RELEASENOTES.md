## 0.18.0

* added `[NSMutableArray mulleRemoveLastObject]` as a convenient pop operation
* `mulle_qsort_pointers` can detect a case of a wrong comparator (possibly should be debug mode only)
* NSArray gains a `mulleContainsObjectIdenticalTo:` method to be interchangeably used with NSSets `member`
* NSMutableArray `-removeObjectsInArray` has been rewritten for speed
* Containers gain a `mulleInitWithContainer:` method, to easily create sets from arrays and dictionaries and vice versa
* `mulleInitWithCapacity:` has been renamed to `mulleInitForCoderWithCapacity:` as to make accidental use less likely
* add `mulleRegisterObject` to **NSMutableSet** which combines `member/addObject:` calls into one
* added -mulleCountCollisions: to check how well the hash performs


### 0.17.2

* remove duplicate objc-loader.inc

### 0.17.1

* new mulle-sde project structure

## 0.17.0

* adapt to renames in mulle-container
* adapt to renames in MulleObjC
* use return value of `MulleObjCValidateRangeAgainstLength` to allow [self count] being passed in as -1
* split off from MulleObjCStandardFoundation

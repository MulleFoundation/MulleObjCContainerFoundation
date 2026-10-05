## 0.26.0


* Add API documentation for NSOrderedSet and NSMutableOrderedSet, covering creation, accessors, mutation, and subclass responsibilities
* Note that NSDictionary enumeration order is unspecified and recommend explicit ordering when output depends on it
* Document performance characteristics of ordered sets and add NSOrderedSet to keywords and class cluster descriptions



feature: add NSOrderedSet and NSMutableOrderedSet containers

* new NSOrderedSet, an insertion-ordered immutable set with set and array access: `count`, `member:`, `indexOfObject:`, `firstObject`/`lastObject`, `array`, `set` and `isEqualToOrderedSet:`
* new NSMutableOrderedSet with `addObject:`, `insertObject:atIndex:`, `removeObject:`, `removeObjectAtIndex:`, `replaceObjectAtIndex:withObject:`, `addObjects:count:`, `addObjectsFromArray:` and capacity based creation
* convenience factories such as `+orderedSetWithObject:`, `+orderedSetWithObjects:count:`, `+orderedSetWithArray:`, `+orderedSetWithSet:` and `+orderedSetWithOrderedSet:`
* full class-cluster implementation (immutable, concrete mutable, empty and placeholder classes) with fast enumeration and NSFastEnumeration support


### 0.25.2



* removing a range of objects now autoreleases all removed elements even when removing to the end of the array

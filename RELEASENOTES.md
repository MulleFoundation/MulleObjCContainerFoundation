### 0.23.2


* containers gain -copy from MulleObjCImmutable
* mutableCopy methods exiled to Foundation

### 0.23.1

* fixed mulleRegisterObject: in NSMutableSet

## 0.23.0


feat: improve container classes and build system

* Enhance container class hierarchy
  - Add MulleObjCContainer base class
  - Move common container code to base class
  - Rename NSEnumerator+NSArray to NSArray+NSEnumerator
  - Add MulleObjCContainer+NSArray category

* Improve build system and CMake support
  - Add CMake package config files
  - Update compiler flags and warnings
  - Add TAO debug support via `OBJC_TAO_DEBUG_ENABLED` option
  - Fix Windows compatibility issues
  - Add sccache support for Linux

* Refactor source organization
  - Move shared code to MulleObjCContainer
  - Update header includes and dependencies
  - Fix file paths and directory structure
  - Clean up obsolete environment settings


## 0.22.0

* changed type of n of `mulle_qsort_pointers` to unsigned int for more consistency
* migrated off `mulle_flexarray_do` towards `mulle_alloca_do`
* **BREAKING CHANGE** as callbacks moved to MulleObjC (mostly) made the remaining callbacks more consistent and not the struct/pointer mish mash they were previously
* new method mulleMoveObjectsInRange:toIndex: on NSMutableArray


### 0.21.1

* Various small improvements

## 0.21.0

* moved callbacks to MulleObjC


### 0.20.1

* change GLOBALs for Windows

## 0.20.0

* Various small improvements


## 0.19.0

* adapt to changes in MulleObjC


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

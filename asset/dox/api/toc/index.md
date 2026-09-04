# MulleObjCContainerFoundation Library Documentation for AI
<!-- Keywords: ObjectiveC, containers, NSArray, NSDictionary, NSSet, immutable, mutable -->
## 1. Introduction & Purpose

- MulleObjCContainerFoundation provides Objective-C container classes (NSArray, NSMutableArray, NSDictionary, NSMutableDictionary, NSSet, NSMutableSet, NSEnumerator) built for the mulle-objc ecosystem.
- Solves: lightweight, portable Objective‑C collection types for projects that use MulleObjC and mulle-container.
- Key features: class clusters, immutable/mutable variants, ObjC-compatible enumeration and convenience helpers (e.g., mulleFirstObject), and "mulle" additions for efficient retained/vararg operations.
- Relationship: depends on MulleObjC and mulle-container; usually included as a component of MulleFoundation.

## 2. Key Concepts & Design Philosophy

- Class cluster design: many public factories return private concrete subclasses; users interact with immutable interfaces for NSArray/NSDictionary/NSSet and mutable subclasses for mutation.
- Immutable vs mutable separation: immutable classes are copy-on-write compatible; mutable variants provide in-place mutation APIs.
- "Mulle" additions: performance and convenience methods (mulleFirstObject, mulle* retained variants) that expose low-level helpers for efficiency.
- API aims for small footprint and compatibility with ObjC idioms (NSFastEnumeration, selectors, selectors with function pointers for custom sorts).

## 3. Core API & Data Structures

Organized by prominent public headers found in src/

### 3.1. [MulleObjCContainer.h]

struct/class: MulleObjCContainer (subclass of NSObject)
- Purpose: common base for container classes; supplies a small set of operations.
- Core operations:
  - makeObjectsPerformSelector: / withObject: / mulleMakeObjectsPerformSelector:withObject:withObject:
  - anyObject: return an arbitrary element
  - objectEnumerator / allObjects (via category)
- Implements NSFastEnumeration in subclasses.

### 3.2. [NSEnumerator.h]

protocol/class: NSEnumerator
- Purpose: iteration protocol and base class.
- Methods: -nextObject; -allObjects; subclasses may implement NSFastEnumeration helpers.

### 3.3. [NSArray/NSMutableArray]

Class: NSArray
- Purpose: immutable ordered collection.
- Creation:
  - +array, +arrayWithArray:, +arrayWithObject:, +arrayWithObjects:..., +arrayWithObjects:count:
  - -initWithArray:, -initWithObjects:..., -initWithObjects:count:
- Core accessors:
  - -count (inherited), -objectAtIndex:, -lastObject, -firstObject (mulleFirstObject), -containsObject:, -indexOfObject:, -indexOfObjectIdenticalTo:
  - -subarrayWithRange:, -arrayByAddingObject:, -arrayByAddingObjectsFromArray:
  - -sortedArrayUsingSelector:/function:
- Mulle additions:
  - -mulleFirstObject, mulleArrayWithObjects/count, mulleForEachObjectCallFunction:argument:preempt:

Class: NSMutableArray
- Purpose: mutable ordered collection.
- Creation:
  - +arrayWithCapacity:, -initWithCapacity:
- Mutation operations:
  - -addObject:, -addObjectsFromArray:, -insertObject:atIndex:, -replaceObjectAtIndex:withObject:
  - -removeLastObject, -removeObject:, -removeObjectAtIndex:, -removeObjectsInRange:, -removeAllObjects
  - -exchangeObjectAtIndex:withObjectAtIndex:, -replaceObjectsInRange:withObjects:count:
  - -sortUsingSelector:/function:
- Mulle additions: mulleAddRetainedObject:, mulleReverseObjects, mulleMoveObjectsInRange:toIndex:, mulleRemoveLastObject

Lifecycle functions: use +factory methods or alloc/initWith... and pair with -copy or -autorelease according to MulleObjC conventions.

### 3.4. [NSDictionary/NSMutableDictionary]

Class: NSDictionary
- Purpose: immutable key-value map.
- Creation:
  - +dictionary, +dictionaryWithDictionary:, +dictionaryWithObject:forKey:, +dictionaryWithObjects:forKeys:count:, +dictionaryWithObjectsAndKeys:
  - -initWithDictionary: / initWithObjects:forKeys:count:
- Core accessors:
  - -objectForKey: (also shorthand -: ), -keyEnumerator, -getObjects:andKeys:, -isEqualToDictionary:
- Extra: mulleForEachObjectAndKeyCallFunction:argument:preempt: for efficient iteration

Class: NSMutableDictionary
- Purpose: mutable key-value map (class cluster)
- Creation:
  - +dictionaryWithCapacity:, -initWithCapacity:
- Mutation operations:
  - -setObject:forKey:, -removeObjectForKey:, -removeAllObjects, -addEntriesFromDictionary:, -setDictionary:
- Mulle additions: mulleSetRetainedObject:forKey:, mulleSetRetainedObject:forCopiedKey:

### 3.5. [NSSet/NSMutableSet]

Class: NSSet
- Purpose: immutable unordered collection with hashing semantics.
- Creation: +set, +setWithArray:, initWithObjects:/count, etc.
- Core ops: containsObject:, anyObject, count, allObjects, keyEnumerator-like methods for iteration.

Class: NSMutableSet
- Purpose: mutable set with addObject:, removeObject:, removeAllObjects, addObjectsFromArray:, etc.

### 3.6. Other headers & helpers

- MullePreempt.h and mulle- additions support preemptable iteration and performance-tuned callbacks.
- Several _*Private.h headers define class-cluster internals (concrete implementations) — not for direct use.

## 4. Performance Characteristics

- NSArray (immutable): O(1) index access, O(n) search unless using indexOf... which is linear. Sorting is O(n log n).
- NSMutableArray: amortized O(1) append (resizing), O(n) insert/remove at arbitrary index.
- NSDictionary/NSSet: hash-table based - average O(1) insertion/lookup/removal, worst-case O(n) in pathological collision scenarios. Headers expose mulleCountCollisions: to inspect collision statistics.
- Thread-safety: Not thread-safe; external synchronization required for concurrent mutation.
- Tradeoffs: class clusters keep API small while allowing specialized concrete implementations tuned for size/speed.

## 5. AI Usage Recommendations & Patterns

- Best practices:
  - Use provided factory and lifecycle methods (e.g., +arrayWithObjects: or -initWithObjects:count:). Respect retain/autorelease patterns of MulleObjC.
  - Prefer immutable APIs when concurrent reads are expected; use mutable variants for in-place mutations.
  - Use mulleForEach... and mulle* retained helpers for performance-critical loops and to avoid extra copies.
- Common pitfalls:
  - Do not rely on concrete private headers (_MulleObjC*). These are class-cluster internals and may change.
  - Many convenience methods return borrowed pointers; do not free them. Follow ObjC memory rules used in project tests.
  - Vararg factory methods require nil termination.
- Idiomatic usage: use NSFastEnumeration where possible, use mulleFirstObject for fast-first-element checks, and use mulleSetRetainedObject: when transferring ownership efficiently.

## 6. Integration Examples

### Example 1: Creating and inspecting an NSArray (from test/10_array/array-basics.m)

```c
#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

int main(void)
{
   @autoreleasepool
   {
      NSArray *a;

      a = [NSArray arrayWithObjects:[Str str:"alpha"], [Str str:"beta"], [Str str:"gamma"], nil];
      mulle_printf("count: %lu\n", (unsigned long)[a count]);
      mulle_printf("first: %s\n", [[a mulleFirstObject] UTF8String]);
      mulle_printf("last: %s\n", [[a lastObject] UTF8String]);
      mulle_printf("index0: %s\n", [[a objectAtIndex:0] UTF8String]);
   }
   return(0);
}
```

### Example 2: Mutable array mutation and removal

```c
NSMutableArray *m = [NSMutableArray arrayWithCapacity:4];
[m addObject:obj1];
[m addObject:obj2];
[m insertObject:obj0 atIndex:0];
[m removeObjectAtIndex:2];
[m replaceObjectAtIndex:1 withObject:newObj];
```

### Example 3: Dictionary creation and lookup

```c
NSDictionary *d = [NSDictionary dictionaryWithObjects:objs forKeys:keys count:count];
id v = [d objectForKey:key];
NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:16];
[md setObject:value forKey:key];
[md removeObjectForKey:key];
```

Notes: See test/ directory (10_array, 20_dictionary, 30_set) for comprehensive, compilable examples and expected stdout.

## 7. Dependencies

- MulleObjC (objective-c runtime roots)
- mulle-container (underlying C container primitives used by some implementations)
- mulle-objc-list (used in testing / integration in broader MulleFoundation)


-- End of TOC --


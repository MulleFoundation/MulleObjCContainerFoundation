# MulleObjCContainerFoundation Library Documentation for AI
<!-- Keywords: collections, containers -->

## 1. Introduction & Purpose

MulleObjCContainerFoundation provides essential Objective-C collection classes including NSArray (ordered sequences), NSDictionary (key-value mapping), NSSet (unique values), and NSEnumerator (collection iteration). These are the primary containers for storing and organizing objects in mulle-objc applications.

## 2. Key Concepts & Design Philosophy

- **Class Clusters**: Uses class cluster pattern for efficient implementations
- **Immutable by Default**: NSArray, NSDictionary, NSSet are immutable
- **Mutable Variants**: NSMutableArray, NSMutableDictionary, NSMutableSet for changes
- **Ownership**: Collections retain stored objects (reference counted)
- **Iteration**: NSEnumerator provides iteration without modifying collections
- **Type Agnostic**: Store any object type; use nil as sentinel

## 3. Core API & Data Structures

### NSArray - Ordered Collection

#### Creation

- `+ arrayWithObjects:(id)obj, ...` → `instancetype`: Create with variadic args (nil-terminated)
- `+ arrayWithObject:(id)obj` → `instancetype`: Single-element array
- `- initWithObjects:(id)obj, ...` → `instancetype`

#### Accessors

- `- count` → `NSUInteger`: Number of elements
- `- objectAtIndex:(NSUInteger)index` → `id`: Get element at index
- `- firstObject` → `id`: First element or nil
- `- lastObject` → `id`: Last element or nil

#### Search

- `- indexOfObject:(id)obj` → `NSUInteger`: Find first index of object (or NSNotFound)
- `- containsObject:(id)obj` → `BOOL`: Check if contains object

#### Manipulation (Immutable)

- `- arrayByAddingObject:(id)obj` → `NSArray *`: Create new array with object appended
- `- subarrayWithRange:(NSRange)range` → `NSArray *`: Create subarray

#### Iteration

- `- enumerator` → `NSEnumerator *`: Get enumerator
- `- reverseEnumerator` → `NSEnumerator *`: Get reverse enumerator

### NSMutableArray - Mutable Array

#### Modification

- `- addObject:(id)obj` → `void`: Add object at end
- `- insertObject:(id)obj atIndex:(NSUInteger)index` → `void`
- `- removeObjectAtIndex:(NSUInteger)index` → `void`
- `- removeObject:(id)obj` → `void`: Remove all occurrences
- `- removeAllObjects` → `void`: Clear array
- `- replaceObjectAtIndex:(NSUInteger)index withObject:(id)obj` → `void`

### NSDictionary - Key-Value Mapping

#### Creation

- `+ dictionaryWithObjectsAndKeys:(id)obj, (id)key, ...` → `instancetype`: Create with pairs (nil-terminated)
- `+ dictionaryWithObject:(id)obj forKey:(id)key` → `instancetype`: Single entry
- `- initWithObjectsAndKeys:(id)obj, (id)key, ...` → `instancetype`

#### Accessors

- `- count` → `NSUInteger`: Number of entries
- `- objectForKey:(id)key` → `id`: Lookup value (nil if not found)
- `- allKeys` → `NSArray *`: Get all keys
- `- allValues` → `NSArray *`: Get all values

#### Iteration

- `- keyEnumerator` → `NSEnumerator *`: Enumerate keys
- `- objectEnumerator` → `NSEnumerator *`: Enumerate values

### NSMutableDictionary - Mutable Dictionary

#### Modification

- `- setObject:(id)obj forKey:(id)key` → `void`: Add or update entry
- `- removeObjectForKey:(id)key` → `void`
- `- removeAllObjects` → `void`

### NSSet - Unique Value Collection

#### Creation

- `+ setWithObjects:(id)obj, ...` → `instancetype`
- `- initWithObjects:(id)obj, ...` → `instancetype`

#### Accessors

- `- count` → `NSUInteger`
- `- containsObject:(id)obj` → `BOOL`
- `- anyObject` → `id`: Arbitrary element

#### Operations

- `- setByAddingObject:(id)obj` → `NSSet *`: New set with object
- `- setByRemovingObject:(id)obj` → `NSSet *`: New set without object

### NSMutableSet - Mutable Set

#### Modification

- `- addObject:(id)obj` → `void`
- `- removeObject:(id)obj` → `void`
- `- removeAllObjects` → `void`

### NSEnumerator - Iterator

#### Iteration

- `- nextObject` → `id`: Get next element (nil when exhausted)
- `- allObjects` → `NSArray *`: Get remaining elements as array

## 4. Performance Characteristics

- **Array Access**: O(1) random access by index
- **Array Search**: O(n) linear search
- **Dictionary Lookup**: O(1) average hash lookup
- **Dictionary Insert**: O(1) average
- **Set Operations**: O(1) average contains/add/remove
- **Iteration**: O(n) for all elements
- **Memory**: Collections retain all objects (strong references)

## 5. AI Usage Recommendations & Patterns

### Best Practices

- **Use Immutable**: NSArray/NSDictionary/NSSet unless modifications needed
- **Nil Termination**: Always end variadic creation with nil
- **Safe Lookup**: Check for nil from dictionary/array access
- **NSNotFound**: Always check for NSNotFound from indexOfObject:
- **Iteration**: Use enumerators or fast enumeration where available

### Common Pitfalls

- **Missing nil Terminator**: Variadic args without nil cause undefined behavior
- **Index Out of Bounds**: Access outside valid indices causes crash
- **NSNotFound Check**: Forgetting NSNotFound check when search fails
- **Nil Keys/Values**: Using nil as key/value may cause issues (use NSNull instead)
- **Mutation During Iteration**: Don't modify collection while iterating

## 6. Integration Examples

### Example 1: Basic NSArray

```objc
#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

int main() {
    NSArray *array = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    
    NSLog(@"Count: %lu", [array count]);
    NSLog(@"First: %@", [array firstObject]);
    NSLog(@"At index 1: %@", [array objectAtIndex:1]);
    
    if ([array containsObject:@"two"]) {
        NSLog(@"Contains two");
    }
    
    return 0;
}
```

### Example 2: Mutable Array Operations

```objc
#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

int main() {
    NSMutableArray *array = [NSMutableArray array];
    
    [array addObject:@"first"];
    [array addObject:@"second"];
    [array insertObject:@"middle" atIndex:1];
    
    NSLog(@"Array: %@", array);
    
    [array removeObjectAtIndex:1];
    NSLog(@"After removal: %@", array);
    
    return 0;
}
```

### Example 3: NSDictionary Lookup

```objc
#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

int main() {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
        @"value1", @"key1",
        @"value2", @"key2",
        nil];
    
    NSLog(@"Count: %lu", [dict count]);
    NSLog(@"key1: %@", [dict objectForKey:@"key1"]);
    
    NSArray *keys = [dict allKeys];
    NSArray *values = [dict allValues];
    NSLog(@"Keys: %@", keys);
    
    return 0;
}
```

### Example 4: NSSet Operations

```objc
#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

int main() {
    NSSet *set = [NSSet setWithObjects:@"apple", @"banana", @"cherry", nil];
    
    NSLog(@"Count: %lu", [set count]);
    
    if ([set containsObject:@"apple"]) {
        NSLog(@"Set contains apple");
    }
    
    NSSet *newSet = [set setByAddingObject:@"date"];
    NSLog(@"New set size: %lu", [newSet count]);
    
    return 0;
}
```

### Example 5: Enumerator Usage

```objc
#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

int main() {
    NSArray *array = [NSArray arrayWithObjects:@"a", @"b", @"c", nil];
    NSEnumerator *enumerator = [array enumerator];
    
    id obj;
    while ((obj = [enumerator nextObject]) != nil) {
        NSLog(@"Object: %@", obj);
    }
    
    return 0;
}
```

### Example 6: Dictionary Enumeration

```objc
#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

int main() {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
        @"Alice", @"name",
        @"Engineer", @"title",
        nil];
    
    NSEnumerator *keyEnum = [dict keyEnumerator];
    id key;
    while ((key = [keyEnum nextObject]) != nil) {
        id value = [dict objectForKey:key];
        NSLog(@"%@: %@", key, value);
    }
    
    return 0;
}
```

## 7. Dependencies

- MulleObjC
- MulleObjCValueFoundation
- MulleFoundationBase

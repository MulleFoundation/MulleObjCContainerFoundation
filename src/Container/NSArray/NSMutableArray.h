/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSMutableArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSArray.h"

#import "NSMutableCopying.h"


@interface NSMutableArray : NSArray
{
   id              *_storage;
   NSUInteger      _count;
   NSUInteger      _size;
   unsigned long   _mutationCount;      // for ObjC 2.0
}

- (id) initWithCapacity:(NSUInteger) capacity;

- (void) addObjectsFromArray:(NSArray *) otherArray;

- (void) addObject:(id) obj;
- (void) insertObject:(id) obj
              atIndex:(NSUInteger) index;
- (void) replaceObjectAtIndex:(NSUInteger) index
                   withObject:(id) obj;
- (void) removeLastObject;
- (void) removeObjectAtIndex:(NSUInteger) index;
- (void) removeObjectsInRange:(NSRange) range;
- (void) removeObjectIdenticalTo:(id) obj;
- (void) removeObjectIdenticalTo:(id) obj
                         inRange:(NSRange) range;
- (void) removeObjectsInArray:(NSArray *) other;

- (void) removeAllObjects;
- (void) exchangeObjectAtIndex:(NSUInteger) index1
             withObjectAtIndex:(NSUInteger) index2;
- (void) replaceObjectsInRange:(NSRange) range
                   withObjects:(id *) objects
                         count:(NSUInteger) count;

- (void) replaceObjectsInRange:(NSRange) aRange 
          withObjectsFromArray:(NSArray *) other;
          
- (void) setArray:(NSArray *) other;

- (void) sortUsingSelector:(SEL)comparator;
- (void) sortUsingFunction:(NSInteger (*)(id, id, void *)) compare 
                   context:(void *) context;
+ (id) arrayWithCapacity:(NSUInteger) capacity;

- (id) initWithArray:(NSArray *) other;
- (id) initWithArray:(NSArray *) other
               range:(NSRange) range;
- (id) initWithObjects:(id *) objects
                 count:(NSUInteger) n;
- (id) initWithObject:(id) object
            arguments:(mulle_vararg_list) args;
- (id) initWithObjects:(id) object, ...;

@end


@interface NSArray( NSMutableCopying) < NSMutableCopying>

- (id) mutableCopy;

@end

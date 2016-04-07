/*
 *  MulleFoundation - A tiny Foundation replacement
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

- (void) addObject:(id) arg1;
- (void) insertObject:(id) arg1 
              atIndex:(NSUInteger) arg2;
- (void) replaceObjectAtIndex:(NSUInteger) arg1 
                   withObject:(id) arg2;
- (void) removeLastObject;
- (void) removeObjectAtIndex:(NSUInteger) arg1;
- (void) removeObjectsInRange:(NSRange) arg1;
- (void) removeObjectIdenticalTo:(id) arg1;
- (void) removeObjectIdenticalTo:(id) anObject 
                         inRange:(NSRange) aRange;
- (void) removeObjectsInArray:(NSArray *)otherArray;

- (void) removeAllObjects;
- (void) exchangeObjectAtIndex:(NSUInteger) arg1 
             withObjectAtIndex:(NSUInteger) arg2;
- (void) replaceObjectsInRange:(NSRange) arg1 
                   withObjects:(id *) arg2 
                         count:(NSUInteger) arg3;

- (void) replaceObjectsInRange:(NSRange) aRange 
          withObjectsFromArray:(NSArray *) otherArray;
          
- (void) setArray:(NSArray *)otherArray;

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

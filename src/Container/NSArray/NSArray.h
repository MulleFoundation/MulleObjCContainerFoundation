/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import <MulleObjC/MulleObjC.h>


@class NSEnumerator;


@interface NSArray : NSObject < MulleObjCClassCluster>

+ (instancetype) array;
+ (instancetype) arrayWithArray:(NSArray *) other;
+ (instancetype) arrayWithObject:(id) obj;
+ (instancetype) arrayWithObjects:(id) firstObject, ...;
+ (instancetype) arrayWithObjects:(id *) objects
                  count:(NSUInteger) count;

- (instancetype) initWithArray:(NSArray *) other;
- (instancetype) initWithArray:(NSArray *) other
                     copyItems:(BOOL) flag;
- (instancetype) initWithObjects:(id) firstObject, ...;
- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count;

- (NSArray *) arrayByAddingObject:(id) obj;
- (NSArray *) arrayByAddingObjectsFromArray:(NSArray *) other;

- (BOOL) containsObject:(id) obj;
- (id) firstObjectCommonWithArray:(NSArray *) other;
- (NSUInteger) indexOfObject:(id) obj;
- (NSUInteger) indexOfObject:(id) obj 
                     inRange:(NSRange) range;
- (NSUInteger) indexOfObjectIdenticalTo:(id) obj;
- (NSUInteger) indexOfObjectIdenticalTo:(id) obj 
                                inRange:(NSRange) range;

- (BOOL) isEqual:(id) other;
- (BOOL) isEqualToArray:(NSArray *) other;
- (id) lastObject;
- (void) makeObjectsPerformSelector:(SEL) sel; 
- (void) makeObjectsPerformSelector:(SEL) sel 
                         withObject:(id) obj;
- (NSEnumerator *) objectEnumerator;
- (NSEnumerator *) reverseObjectEnumerator;
- (NSArray *) sortedArrayUsingFunction:(NSInteger (*)(id, id, void *)) comparator 
                               context:(void *) context;
- (NSArray *) sortedArrayUsingSelector:(SEL) comparator;
- (NSArray *) subarrayWithRange:(NSRange) range;


- (NSUInteger) hash;

- (BOOL) containsObject:(id) obj
                inRange:(NSRange) range;
- (void) getObjects:(id *) objects;

@end


@interface NSArray( Subclasses)

- (NSUInteger) count;
- (id) objectAtIndex:(NSUInteger) index;
- (void) getObjects:(id *) objects
              range:(NSRange) range;

@end

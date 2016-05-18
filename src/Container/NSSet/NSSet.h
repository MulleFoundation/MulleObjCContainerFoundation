/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSSet.h is a part of MulleFoundation
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


@interface NSSet : NSObject < MulleObjCClassCluster, NSCoding, NSCopying>
{
}

+ (instancetype) set;

+ (instancetype) setWithObject:(id) object;
+ (instancetype) setWithObjects:(id) object, ...;
+ (instancetype) setWithObjects:(id *) objects
                          count:(NSUInteger) count;
+ (instancetype) setWithSet:(NSSet *) set;
- (instancetype) setByAddingObject:(id) object;
- (instancetype) setByAddingObjectsFromSet:(NSSet *) set ;
- (instancetype) initWithObjects:(id) object, ...;
- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count;
- (instancetype) initWithSet:(NSSet *) set
                   copyItems:(BOOL) flag;

- (id) anyObject;
- (BOOL) containsObject:(id) object;

- (BOOL) isSubsetOfSet:(NSSet *) set;
- (BOOL) intersectsSet:(NSSet *) set;
- (BOOL) isEqualToSet:(NSSet *) set;

@end

@interface NSSet( Subclass)

// designated initializer
- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
                       copyItems:(BOOL) flag;

- (instancetype) initWithObject:(id) object
                      arguments:(mulle_vararg_list) args;

/* subclasses need to override those */
- (NSUInteger) count;
- (id) member:(id) object;
- (NSEnumerator *) objectEnumerator;

@end



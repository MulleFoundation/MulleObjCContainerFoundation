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
#import "NSSet.h"


@class NSArray;


@interface NSSet( NSArray)

+ (id) setWithArray:(NSArray *) array;
- (id) setByAddingObjectsFromArray:(NSArray *) array;

- (id) initWithArray:(NSArray *) array;
- (NSArray *) allObjects;

- (void) makeObjectsPerformSelector:(SEL) sel;
- (void) makeObjectsPerformSelector:(SEL) sel 
                         withObject:(id) object;
@end

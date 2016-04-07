/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSEnumerator+NSArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSEnumerator.h"


@class NSArray;


@interface NSEnumerator( NSArray)

- (NSArray *) allObjects;
- (void) makeObjectsPerformSelector:(SEL) sel;
- (void) makeObjectsPerformSelector:(SEL) sel
                         withObject:(id) obj;

@end

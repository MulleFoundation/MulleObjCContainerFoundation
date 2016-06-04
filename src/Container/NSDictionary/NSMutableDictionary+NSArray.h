/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSMutableDictionary+NSArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSMutableDictionary.h"


@class NSArray;


@interface NSMutableDictionary( NSArray)

- (void) removeObjectsForKeys:(NSArray *) array;

@end

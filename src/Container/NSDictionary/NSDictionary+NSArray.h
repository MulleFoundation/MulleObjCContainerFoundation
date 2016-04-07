/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSDictionary+NSArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSDictionary.h"


@class NSArray;


@interface NSDictionary( NSArray)

+ (id) dictionaryWithObjects:(NSArray *)objects 
                     forKeys:(NSArray *)keys;

- (id) initWithObjects:(NSArray *) objects 
               forKeys:(NSArray *) keys;
- (NSArray *) keysSortedByValueUsingSelector:(SEL) comparator;
- (NSArray *) objectsForKeys:(NSArray *) keys 
              notFoundMarker:(id) anObject;

- (NSArray *) allKeys;
- (NSArray *) allKeysForObject:(id) anObject;
- (NSArray *) allValues;

@end

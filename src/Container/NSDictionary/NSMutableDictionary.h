/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMutableDictionary.h is a part of MulleFoundation
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

#import "NSMutableCopying.h"

#import <mulle_container/mulle_container.h>


@interface NSMutableDictionary : NSDictionary
{
   struct mulle_map  _table;
}

+ (id) dictionaryWithCapacity:(NSUInteger) capacity;

@end


@interface NSMutableDictionary( _Subclasses)

- (id) initWithCapacity:(NSUInteger) capacity;

- (void) addEntriesFromDictionary:(NSDictionary *) other;

- (void) removeAllObjects;
- (void) removeObjectForKey:(id)aKey;
- (void) setDictionary:(NSDictionary *) other;
- (void) setObject:(id) anObject 
            forKey:(id <NSCopying>) aKey;

@end


@interface NSDictionary ( NSMutableDictionary) < NSMutableCopying>

- (id) mutableCopy;

@end



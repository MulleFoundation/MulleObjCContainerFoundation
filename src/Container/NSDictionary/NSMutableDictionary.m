/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMutableDictionary.m is a part of MulleFoundation
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

// other files in this library
#import "MulleObjCContainerCallback.h"
#import "NSEnumerator.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


#define NSDictionaryCallback           ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueRetainCallback)
#define NSDictionaryCopyValueCallback  ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueCopyCallback)


@implementation NSObject( NSMutableDictionary)

- (BOOL) __isNSMutableDictionary
{
   return( NO);
}

@end


@implementation NSMutableDictionary

- (BOOL) __isNSMutableDictionary
{
   return( YES);
}


+ (id) dictionary
{
   return( [[[self alloc] initWithCapacity:0] autorelease]);
}


+ (id) dictionaryWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


- (id) initWithCapacity:(NSUInteger) capacity
{
   mulle_map_init( &self->_table, capacity, NSDictionaryCallback, MulleObjCObjectGetAllocator( self));
   return( self);
}


- (id) init
{
   mulle_map_init( &self->_table, 16, NSDictionaryCallback, MulleObjCObjectGetAllocator( self));
   return( self);
}


- (void) setObject:(id) obj
            forKey:(NSObject <NSCopying> *) key
{
   assert( [key respondsToSelector:@selector( copyWithZone:)]);
   assert( [key respondsToSelector:@selector( hash)]);
   assert( [key respondsToSelector:@selector( isEqual:)]);
   assert( [obj respondsToSelector:@selector( retain)]);
   
   mulle_map_set( &_table, key, obj);
}


- (id) objectForKey:(id) key
{
   return( mulle_map_get( &_table, key));
}


- (void) removeObjectForKey:(id) key
{
   mulle_map_remove( &_table, key);
}


- (void) addEntriesFromDictionary:(NSDictionary *) other
{
   NSEnumerator   *rover;
   id             key;
   id             value;
   
   rover = [other keyEnumerator];
   while( key = [rover nextObject])
   {
      value = [other objectForKey:key];
      [self setObject:value
      forKey:key];
   }
}


- (void) removeAllObjects
{
   mulle_map_reset( &_table);
}


- (void) setDictionary:(NSDictionary *) other
{
   [self removeAllObjects];
   [self addEntriesFromDictionary:other];
}


- (id) copy
{
   return( (id) [[NSDictionary alloc] initWithDictionary:self]);
}

@end


@implementation NSDictionary ( NSMutableDictionary) 

- (id) mutableCopy
{
   return( [[NSMutableDictionary alloc] initWithDictionary:self]);
}

@end



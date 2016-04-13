/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSSet+NSArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSSet+NSArray.h"

// other files in this library
#import "NSArray.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSSet( NSArray)


+ (id) setWithArray:(NSArray *) array
{
   NSSet  *set;
   id     *
   if( self != __NSSetClass && self != __NSMutableSetClass)
      return( NSAutoreleaseObject( [[self allocWithZone:NULL] initWithArray:array]));
      
   set = [self alloc];
   if( [array _pointerArray])
   NSInitSet( set, [array count]);
   [self addObjectsFromEnumerator:[array objectEnumerator]
                      toHashTable:get_hash_table( set)
                        copyItems:NO];
   return( NSAutoreleaseObject( set));
}


- (id) initWithArray:(NSArray *) array
{
   NSInitSet( self, [array count]);
   [isa addObjectsFromEnumerator:[array objectEnumerator]
                     toHashTable:get_hash_table( self)
                       copyItems:NO];
   return( self);
}


- (NSArray *) allObjects
{
   return( MulleObjCAllHashTableObjects( get_hash_table( self)));
}


- (void) makeObjectsPerformSelector:(SEL) sel
{
   [[self objectEnumerator] makeObjectsPerformSelector:sel];
}


- (void) makeObjectsPerformSelector:(SEL) sel 
                         withObject:(id) obj
{
   [[self objectEnumerator] makeObjectsPerformSelector:sel
                                            withObject:obj];
}


- (id) setByAddingObjectsFromArray:(NSArray *) array
{
   NSSet  *set;

   set = [NSSet setWithObjects:array];
   return( [self setByAddingObjectsFromSet:set]);
}

@end

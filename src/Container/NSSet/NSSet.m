/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSSet.m is a part of MulleFoundation
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

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


#import "NSEnumerator.h"
#import "_MulleObjCConcreteSet.h"
#import "MulleObjCContainerCallback.h"

#include <mulle_container/mulle_container.h>
#include "ns_foundationconfiguration.h"


@interface _MulleObjCEmptySet : NSSet < MulleObjCSingleton>
@end


@implementation _MulleObjCEmptySet

+ (instancetype) new
{
   return( NSAllocateObject( self, 0, NULL));
}


- (NSEnumerator *) objectEnumerator
{
   return( nil);
}


- (NSUInteger) count
{
   return( 0);
}

@end



@implementation NSObject( NSSet)

- (BOOL) __isNSSet
{
   return( NO);
}

@end


@implementation NSSet

- (BOOL) __isNSSet
{
   return( YES);
}

#pragma mark -
#pragma mark common classcluster inits


- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
                       copyItems:(BOOL) copyItems
{
   [self release];
   if( ! count)
      return( [_MulleObjCEmptySet new]);
   return( [_MulleObjCConcreteSet newWithObjects:objects
                                           count:count
                                       copyItems:copyItems]);
}


- (instancetype) initWithObject:(id) firstObject
                      arguments:(mulle_vararg_list) arguments
{
   [self release];
   return( [_MulleObjCConcreteSet newWithObject:firstObject
                                      arguments:arguments]);
}


#pragma mark -
#pragma mark common initializers


- (instancetype) initWithSet:(NSSet *) other
{
   NSSet        *set;
   NSUInteger   otherCount;
   id           *buf;
   id           *toFree;

   buf        = toFree = NULL;
   otherCount = [other count];
   if( otherCount)
   {
      if( otherCount < 32)
         buf = alloca( sizeof( id) * otherCount);
      if( ! buf)
         toFree = buf = MulleObjCAllocateNonZeroedMemory( sizeof( id) * otherCount);

      [other getObjects:buf
                  count:otherCount];
   }

   set = [self initWithObjects:buf
                         count:otherCount
                     copyItems:NO];
   MulleObjCDeallocateMemory( toFree);

   return( set);
}


- (instancetype) init
{
   return( [self initWithObjects:NULL
                           count:0
                           copyItems:NO]);
}


- (instancetype) initWithObjects:(id *) buf
                           count:(NSUInteger) count
{
   return( [self initWithObjects:buf
                           count:count
                       copyItems:NO]);
}


- (instancetype) initWithSet:(NSSet *) other
                   copyItems:(BOOL) flag
{
   NSSet        *set;
   NSUInteger   otherCount;
   id           *buf;
   id           *toFree;

   buf        = toFree = NULL;
   otherCount = [other count];
   if( otherCount)
   {
      if( otherCount < 32)
         buf = alloca( sizeof( id) * otherCount);
      if( ! buf)
         toFree = buf = MulleObjCAllocateNonZeroedMemory( sizeof( id) * otherCount);

      [other getObjects:buf
                  count:otherCount];
   }

   set = [self initWithObjects:buf
                         count:otherCount
                     copyItems:flag];

   MulleObjCDeallocateMemory( toFree);

   return( set);
}


- (instancetype) initWithObjects:(id) firstObject , ...
{
   mulle_vararg_list   args;
   
   mulle_vararg_start( args, firstObject);
   
   self = [self initWithObject:firstObject
                     arguments:args];
   
   mulle_vararg_end( args);
   return( self);
}


#pragma mark -
#pragma mark conveniences



// compiler: need an @alias( alloc, whatever), so that implementations
//           can  be shared


+ (id) set
{
   return( [[[self alloc] initWithObjects:NULL
                                    count:0] autorelease]);
}


- (NSUInteger) hash
{
   return( [[self anyObject] hash]);
}


+ (id) setWithSet:(NSSet *) other
{
   return( [[other copy] autorelease]);
}


+ (id) setWithObject:(id) object
{
   return( [[[self alloc] initWithObjects:&object
                                    count:1] autorelease]);
}

+ (instancetype) setWithObjects:(id) firstObject, ...
{
   mulle_vararg_list   args;
   NSSet               *set;
   
   mulle_vararg_start( args, firstObject);

   set = [[[self alloc] initWithObject:firstObject
                             arguments:args] autorelease];
   mulle_vararg_end( args);
   
   return( set);
}


+ (id) setWithObjects:(id *) objects
                count:(NSUInteger) count
{
   return( [[[self alloc] initWithObjects:objects
                                    count:count] autorelease]);
}


- (id) anyObject
{
   return( [[self objectEnumerator] nextObject]);
}


- (BOOL) containsObject:(id) obj
{
   return( [self member:obj] != nil);
}


static BOOL   run_member_on_set_until( NSSet *self, NSSet *other, BOOL expect)
{
   NSEnumerator   *rover;
   IMP            impNext;
   SEL            selNext;
   IMP            impMember;
   SEL            selMember;
   id             obj;
   
   rover = [self objectEnumerator];

   selNext = @selector( nextObject);
   impNext = [rover methodForSelector:selNext];

   selMember = @selector( member:);
   impMember = [other methodForSelector:selMember];
   
   while( obj = (*impNext)( rover, selNext, NULL))
      if( (intptr_t) (*impMember)( other, selMember, obj) == expect)
         return( YES);

   return( NO);
}


- (BOOL) isSubsetOfSet:(NSSet *) other
{
   NSUInteger     n;
   NSUInteger     m;
   
   n = [self count];
   if( ! n)
      return( YES);
      
   m = [other count];
   if( m > n)
      return( NO);
      
   return( ! run_member_on_set_until( self, other, NO));
}


- (BOOL) intersectsSet:(NSSet *) other
{
   return( run_member_on_set_until( self, other, YES));
}


//
// is [NSSet set] equal to nil ? good question
//
- (BOOL) isEqualToSet:(NSSet *) other
{
   if( [self count] != [other count])
      return( NO);
   
   //
   // if we find something where other says NO to
   // member, we know they are not equal
   //
   return( ! run_member_on_set_until( self, other, NO));
}


- (void) getObjects:(id *) objects
              count:(NSUInteger) count
{
   NSEnumerator  *rover;
   id            *sentinel;

   sentinel = &objects[ count];

   // try fast enumeration sometime...
   rover = [self objectEnumerator];
   while( objects < sentinel)
      *objects++ = [rover nextObject];  // zero fills the buf, if needed
}


- (id) copy
{
   NSSet        *set;
   NSUInteger   count;
   id           *buf;
   id           *toFree;

   count    = [self count];
   buf      = toFree = NULL;
   if( count < 32)
      buf = alloca( sizeof( id) * count);
   
   if( ! buf)
      toFree = buf = MulleObjCAllocateNonZeroedMemory( sizeof( id) * count);

   [self getObjects:buf
              count:count];

   set = [self initWithObjects:buf
                         count:count
                     copyItems:NO];
   MulleObjCDeallocateMemory( toFree);
   
   return( set);
}


- (id) setByAddingObject:(id) obj
{
   NSSet        *set;
   NSUInteger   count;
   NSUInteger   newCount;
   id           *buf;
   id           *toFree;

   if( ! obj)
      return( [self immutableInstance]);

   count    = [self count];
   newCount = count + 1;
   buf      = toFree = NULL;
   if( newCount < 32)
      buf = alloca( sizeof( id) * newCount);
   
   if( ! buf)
      toFree = buf = MulleObjCAllocateNonZeroedMemory( sizeof( id) * newCount);

   [self getObjects:buf
              count:count];
   buf[ count] = obj;
   set         = [self initWithObjects:buf
                                 count:newCount
                             copyItems:NO];
   MulleObjCDeallocateMemory( toFree);
   return( set);
}


- (id) setByAddingObjectsFromSet:(NSSet *) other 
{
   NSSet        *set;
   NSUInteger   count;
   NSUInteger   otherCount;
   NSUInteger   newCount;
   id           *buf;
   id           *toFree;
   
   otherCount = [other count];
   
   // possibly return self
   if( ! otherCount)
      return( [self immutableInstance]);
   
   count   = [self count];
   newCount = count + otherCount;
   buf      = toFree = NULL;
   if( newCount < 32)
      buf = alloca( sizeof( id) * newCount);
   
   if( ! buf)
      toFree = buf = MulleObjCAllocateNonZeroedMemory( sizeof( id) * newCount);

   [self getObjects:buf
              count:count];
   [other getObjects:&buf[ count]
               count:otherCount];

   set = [self initWithObjects:buf
                         count:newCount
                     copyItems:NO];
   
   MulleObjCDeallocateMemory( toFree);
   return( set);
}

@end





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

#import "NSEnumerator.h"
#import "_MulleObjCConcreteSet.h"
#import "_MulleObjCContainerCallback.h"

#include <mulle_container/mulle_container.h>
#include "ns_foundationconfiguration.h"


@interface _MulleObjCEmptySet : NSSet < MulleObjCSingleton>
@end


@implementation _MulleObjCEmptySet

- (NSEnumerator *) objectEnumerator
{
   return( nil);
}


- (NSUInteger) count
{
   return( 0);
}

@end


#define MulleObjCSetAllocPlaceholderHash         0x331bd8f6291d398e  // MulleObjCSetAllocPlaceholder
#define MulleObjCSetInstantiatePlaceholderHash   0x56fb1f12fb5bee1f  // MulleObjCSetInstantiatePlaceholder


@interface MulleObjCSetAllocPlaceholder : NSSet
@end


@implementation MulleObjCSetAllocPlaceholder

- (id) initWithObjects:(id *) objects
                 count:(NSUInteger) count
             copyItems:(BOOL) copyItems
{
   _MulleObjCConcreteSet   *set;
   
   [self autorelease];  // placeholder (just release it, since it's a global)
   
   if( ! count)
      return( (id) [[_MulleObjCEmptySet sharedInstance] retain]);
   
   return( (id) [[_MulleObjCConcreteSet alloc] initWithObjects:objects
                                                    count:count
                                                copyItems:copyItems]);
}

@end


@interface MulleObjCSetInstantiatePlaceholder : MulleObjCSetAllocPlaceholder
@end


@implementation MulleObjCSetInstantiatePlaceholder

- (id) initWithObjects:(id *) objects
                 count:(NSUInteger) count
            copyItems:(BOOL) copyItems
{
   _MulleObjCConcreteSet   *set;
   
   [self release];  // placeholder (just release it, since it's a global)
   if( ! count)
      return( (id) [[_MulleObjCEmptySet sharedInstance] retain]);
   
   return( (id) [[_MulleObjCConcreteSet alloc] initWithObjects:objects
                                                    count:count
                                                copyItems:copyItems]);
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


+ (mulle_objc_classid_t) __allocPlaceholderClassid
{
   return( MULLE_OBJC_CLASSID( MulleObjCSetAllocPlaceholderHash));
}


+ (mulle_objc_classid_t) __instantiatePlaceholderClassid
{
   return( MULLE_OBJC_CLASSID( MulleObjCSetInstantiatePlaceholderHash));
}


// compiler: need an @alias( alloc, whatever), so that implementations
//           can  be shared




+ (id) set
{
   return( [[self instantiate] initWithObjects:NULL
                                         count:0]);
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
   return( [[self instantiate] initWithObjects:&object
                                         count:1]);
}

+ (instancetype) setWithObjects:(id) firstObject, ...
{
   mulle_vararg_list   args;
   NSSet                    *set;
   
   mulle_vararg_start( args, firstObject);

   set = [[self instantiate] initWithObject:firstObject
                                  arguments:args];
   mulle_vararg_end( args);
   
   return( set);
}



+ (id) setWithObjects:(id *) objects
                count:(NSUInteger) count
{
   return( [[[self alloc] initWithObjects:objects
                                    count:count] autorelease]);
}



- (id) initWithObjects:(id) firstObject , ...
{
   mulle_vararg_list   args;
   
   mulle_vararg_start( args, firstObject);

   self = [self initWithObject:firstObject
                     arguments:args];
   
   mulle_vararg_end( args);
   return( self);
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
   NSEnumerator   *rover;
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
   NSUInteger   newCount;
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



- (id) initWithSet:(NSSet *) other
{
   NSSet        *set;
   NSUInteger   otherCount;
   id           *buf;
   id           *toFree;
   id           *q;
   id           p;

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


- (id) initWithObjects:(id *) buf
                 count:(NSUInteger) count
{
   return( [self initWithObjects:buf
                           count:count
                       copyItems:NO]);
}


- (id) initWithSet:(NSSet *) other
         copyItems:(BOOL) flag
{
   NSSet        *set;
   NSUInteger   otherCount;
   id           *buf;
   id           *toFree;
   id           *q;
   id           p;

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


@end





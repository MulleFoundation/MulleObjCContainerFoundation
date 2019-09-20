//
//  NSSet.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#pragma clang diagnostic ignored "-Wparentheses"
#pragma clang diagnostic ignored "-Wprotocol"

#import "NSSet.h"

// other files in this library
#import "NSEnumerator.h"
#import "_NSSetPlaceholder.h"

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"

// std-c and dependencies
#include <mulle-container/mulle-container.h>



@implementation NSObject( _NSSet)

- (BOOL) __isNSSet
{
   return( NO);
}

@end


//
// Bauernregel:  NSSet weiss nichts von den konkreten Klassen und eigentlich auch
//               nichts vom Platzhalter.
//
@implementation NSSet

- (BOOL) __isNSSet
{
   return( YES);
}


- (id) mulleImmutableInstance
{
   return( self);
}


#pragma mark -
#pragma mark common classcluster inits


+ (Class) __placeholderClass
{
   return( [_NSSetPlaceholder class]);
}


static id   initWithObjects( id self, id *objects, NSUInteger count, BOOL copyItems)
{
   if( ! objects)
      MulleObjCThrowInvalidArgumentException( @"empty objects");

   // retain or copy objects
   if( copyItems)
      MulleObjCMakeObjectsPerformSelector( objects, count, @selector( copy), NULL);
   else
      MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjects:objects
                                        count:count]);
}

static id   initWithObjectStorage( id self, id *storage, NSUInteger count, BOOL copyItems)
{
   // retain or copy objects
   if( copyItems)
      MulleObjCMakeObjectsPerformSelector( storage, count, @selector( copy), NULL);
   else
      MulleObjCMakeObjectsPerformRetain( storage, count);

   return( [self mulleInitWithRetainedObjectStorage:storage
                                              count:count
                                               size:count]);
}


- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
                       copyItems:(BOOL) copyItems
{
   if( ! count)
      return( [self init]);

   return( initWithObjects( self, objects, count, copyItems));
}


- (instancetype) initWithObject:(id) obj
                mulleVarargList:(mulle_vararg_list) args
{
   NSUInteger   count;
   id           *storage;
   id           *objects;
   id           value;

   if( ! obj)
      return( [self init]);

   count   = mulle_vararg_count_objects( args, obj);
   storage = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   objects = storage;

   value = obj;
   while( value)
   {
      *objects++ = value;
      value      = mulle_vararg_next_id( args);
   }

   return( initWithObjectStorage( self, storage, count, NO));
}


#pragma mark -
#pragma mark common initializers


- (instancetype) initWithSet:(NSSet *) other
{
   return( [self initWithSet:other
                   copyItems:NO]);
}


- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
{
   if( ! count)
      return( [self init]);
   return( initWithObjects( self, objects, count, NO));
}


- (instancetype) initWithSet:(NSSet *) other
                   copyItems:(BOOL) copyItems
{
   NSUInteger   count;
   id           *storage;

   count = [other count];
   if( ! count)
      return( [self init]);

   storage = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   [other getObjects:storage
               count:count];

   return( initWithObjectStorage( self, storage, count, copyItems));
}


- (instancetype) initWithObjects:(id) firstObject , ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, firstObject);

   self = [self initWithObject:firstObject
               mulleVarargList:args];

   mulle_vararg_end( args);
   return( self);
}


#pragma mark -
#pragma mark conveniences

// compiler: need an @alias( alloc, whatever), so that implementations
//           can  be shared


+ (instancetype) set
{
   return( [[[self alloc] initWithObjects:NULL
                                    count:0] autorelease]);
}


+ (instancetype) setWithSet:(NSSet *) other
{
   return( [[[self alloc] initWithSet:other
                            copyItems:NO] autorelease]);
}


+ (instancetype) setWithObject:(id) object
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
                       mulleVarargList:args] autorelease];
   mulle_vararg_end( args);

   return( set);
}


+ (instancetype) setWithObjects:(id *) objects
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
   IMP   impMember;
   SEL   selMember;
   id    obj;

   if( ! other)
      return( NO);

   selMember = @selector( member:);
   impMember = [other methodForSelector:selMember];

   for( obj in self)
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
// hard to pick anything off a NSet, since the implementation
// is free to order them as they like
//

#pragma mark - hash and equality

- (NSUInteger) hash
{
   return( mulle_hash_avalanche( [self count]));
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSSet])
      return( NO);
   return( [self isEqualToSet:other]);
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


- (NSSet *) setByAddingObject:(id) obj
{
   NSSet        *set;
   NSUInteger   count;
   NSUInteger   size;
   id           *storage;

   if( ! obj)
      return( [self mulleImmutableInstance]);

   count = [self count];
   size  = count + 1;

   storage = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * size);
   [self getObjects:storage
               count:count];
   storage[ count] = obj;
   set = [MulleObjCObjectGetClass( self) setWithObjects:storage
                                          count:size];
   MulleObjCObjectDeallocateMemory( self, storage);
   return( set);
}


- (NSSet *) mulleSetByAddingObjectsFromContainer:(id) other
{
   NSSet        *set;
   NSUInteger   count;
   NSUInteger   otherCount;
   NSUInteger   size;
   id           *storage;

   otherCount = [other count];
   if( ! otherCount)
      return( [self mulleImmutableInstance]);

   count = [self count];
   size  = count + otherCount;

   storage = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * size);
   [self getObjects:storage
               count:count];
   [other getObjects:&storage[ count]
               count:otherCount];
   set = [MulleObjCObjectGetClass( self) setWithObjects:storage
                                          count:size];
   MulleObjCObjectDeallocateMemory( self, storage);
   return( set);
}

- (NSSet *) setByAddingObjectsFromSet:(NSSet *) set
{
   return( [self mulleSetByAddingObjectsFromContainer:set]);
}


- (id) copy
{
   return( [self retain]);
}


- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) rover
                                   objects:(id *) buffer
                                     count:(NSUInteger) len;
{
   abort();  // subclass must do this
}

@end

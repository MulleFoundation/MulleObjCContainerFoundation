//
//  NSOrderedSet.m
//  MulleObjCContainerFoundation
//
//  Copyright (c) 2026 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
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

#import "NSOrderedSet.h"

// other files in this library
#import "NSArray.h"
#import "NSEnumerator.h"
#import "NSMutableSet.h"
#import "_NSOrderedSetPlaceholder.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies
#import "import-private.h"


@interface NSSet( PrivateForOrderedSet)

- (void) getObjects:(id *) objects
              count:(NSUInteger) count;

@end


@implementation NSObject( _NSOrderedSet)

- (BOOL) __isNSOrderedSet
{
   return( NO);
}

@end


@implementation NSOrderedSet

- (BOOL) __isNSOrderedSet
{
   return( YES);
}


- (id) mulleImmutableInstance
{
   return( self);
}


#pragma mark - class cluster


+ (Class) __classClusterClass
{
   return( [_NSOrderedSetPlaceholder class]);
}


static id   initWithObjectStorage( id self, id *storage, NSUInteger count)
{
   // retain objects, the storage is given to mulleInit...
   MulleObjCMakeObjectsPerformRetain( storage, count);
   return( [self mulleInitWithRetainedObjectStorage:storage
                                              count:count
                                               size:count]);
}


#pragma mark - common initializers


- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
{
   if( ! count)
      return( [self init]);
   if( ! objects)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "empty objects");

   MulleObjCMakeObjectsPerformRetain( objects, count);
   return( [self mulleInitWithRetainedObjects:objects
                                        count:count]);
}


- (instancetype) initWithObject:(id) object
                mulleVarargList:(mulle_vararg_list) args
{
   NSUInteger   count;
   id           *storage;
   id           *objects;
   id           value;

   if( ! object)
      return( [self init]);

   count   = mulle_vararg_count_objects( args, object);
   storage = MulleObjCInstanceAllocateNonZeroedMemory( self, sizeof( id) * count);
   objects = storage;

   value = object;
   while( value)
   {
      *objects++ = value;
      value      = mulle_vararg_next_id( args);
   }

   return( initWithObjectStorage( self, storage, count));
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


- (instancetype) initWithArray:(NSArray *) array
{
   NSUInteger   count;
   id           *storage;

   count = [array count];
   if( ! count)
      return( [self init]);

   storage = MulleObjCInstanceAllocateNonZeroedMemory( self, sizeof( id) * count);
   [array getObjects:storage];

   return( initWithObjectStorage( self, storage, count));
}


- (instancetype) initWithSet:(NSSet *) set
{
   NSUInteger   count;
   id           *storage;

   count = [set count];
   if( ! count)
      return( [self init]);

   storage = MulleObjCInstanceAllocateNonZeroedMemory( self, sizeof( id) * count);
   [set getObjects:storage
             count:count];

   return( initWithObjectStorage( self, storage, count));
}


- (instancetype) initWithOrderedSet:(NSOrderedSet *) set
{
   NSUInteger   count;
   id           *storage;

   count = [set count];
   if( ! count)
      return( [self init]);

   storage = MulleObjCInstanceAllocateNonZeroedMemory( self, sizeof( id) * count);
   [set getObjects:storage
             range:NSRangeMake( 0, count)];

   return( initWithObjectStorage( self, storage, count));
}


- (instancetype) initWithObject:(id) object
{
   if( ! object)
      return( [self init]);

   return( [self initWithObjects:&object
                           count:1]);
}


#pragma mark - conveniences


@method_implementation +orderedSet = +instance;

+ (instancetype) orderedSetWithObject:(id) object
{
   return( [[[self alloc] initWithObject:object] autorelease]);
}


+ (instancetype) orderedSetWithObjects:(id) firstObject, ...
{
   mulle_vararg_list   args;
   NSOrderedSet        *set;

   mulle_vararg_start( args, firstObject);
   set = [[[self alloc] initWithObject:firstObject
                       mulleVarargList:args] autorelease];
   mulle_vararg_end( args);

   return( set);
}


+ (instancetype) orderedSetWithObjects:(id *) objects
                                 count:(NSUInteger) count
{
   return( [[[self alloc] initWithObjects:objects
                                    count:count] autorelease]);
}


+ (instancetype) orderedSetWithArray:(NSArray *) array
{
   return( [[[self alloc] initWithArray:array] autorelease]);
}


+ (instancetype) orderedSetWithSet:(NSSet *) set
{
   return( [[[self alloc] initWithSet:set] autorelease]);
}


+ (instancetype) orderedSetWithOrderedSet:(NSOrderedSet *) set
{
   return( [[[self alloc] initWithOrderedSet:set] autorelease]);
}


#pragma mark - generic accessors


- (id) firstObject
{
   if( ! [self count])
      return( nil);
   return( [self objectAtIndex:0]);
}


- (id) lastObject
{
   NSUInteger   count;

   count = [self count];
   if( ! count)
      return( nil);
   return( [self objectAtIndex:count - 1]);
}


- (BOOL) containsObject:(id) object
{
   return( [self member:object] != nil);
}


- (NSUInteger) indexOfObject:(id) object
{
   NSUInteger   count;
   NSUInteger   i;
   id           other;

   count = [self count];
   for( i = 0; i < count; i++)
   {
      other = [self objectAtIndex:i];
      if( other == object || [other isEqual:object])
         return( i);
   }
   return( NSNotFound);
}


- (void) getObjects:(id *) objects
              range:(NSRange) range
{
   NSUInteger   i;
   NSUInteger   n;

   range = MulleObjCValidateRangeAgainstLength( range, [self count]);
   n     = range.length;
   for( i = 0; i < n; i++)
      objects[ i] = [self objectAtIndex:range.location + i];
}


#pragma mark - conversions


- (NSArray *) array
{
   return( (NSArray *) [[self objectEnumerator] allObjects]);
}


- (NSSet *) set
{
   NSMutableSet   *set;
   id             object;

   set = [NSMutableSet set];
   for( object in self)
      [set addObject:object];
   return( set);
}


#pragma mark - hash and equality


- (NSUInteger) hash
{
   return( mulle_hash_avalanche( [self count]));
}


- (BOOL) isEqualToOrderedSet:(NSOrderedSet *) other
{
   NSUInteger   count;
   NSUInteger   i;
   id           a;
   id           b;

   if( other == self)
      return( YES);

   count = [self count];
   if( count != [other count])
      return( NO);

   for( i = 0; i < count; i++)
   {
      a = [self objectAtIndex:i];
      b = [other objectAtIndex:i];
      if( a == b)
         continue;
      if( ! [a isEqual:b])
         return( NO);
   }
   return( YES);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSOrderedSet])
      return( NO);
   return( [self isEqualToOrderedSet:other]);
}


- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) rover
                                   objects:(id *) buffer
                                     count:(NSUInteger) len
{
   MULLE_C_UNUSED( rover);
   MULLE_C_UNUSED( buffer);
   MULLE_C_UNUSED( len);
   abort();  // subclass must do this
}

@end

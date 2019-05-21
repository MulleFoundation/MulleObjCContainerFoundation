//
//  NSArray.m
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

#import "NSArray.h"

// other files in this library
#import "_MulleObjCArrayEnumerator.h"
#import "_NSArrayPlaceholder.h"
#include "mulle-qsort-pointers.h"

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"

// std-c and dependencies

// private headers in this library


#pragma clang diagnostic ignored "-Wprotocol"


@implementation NSObject( _NSArray)

- (BOOL) __isNSArray
{
   return( NO);
}

@end


@implementation NSArray

- (BOOL) __isNSArray
{
   return( YES);
}


static Class   NSArrayClass;

+ (void) load
{
   NSArrayClass = self;
}


+ (Class) __placeholderClass
{
   return( [_NSArrayPlaceholder class]);
}


- (id) mulleImmutableInstance
{
   return( self);
}


# pragma mark -
# pragma mark class cluster

- (instancetype) initWithArray:(NSArray *) other
{
   NSUInteger   count;
   id           *objects;

   count     = [other count];
   if( ! count)
   {
      self = [self init];
      return( self);
   }

   objects   = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   [other getObjects:objects];

   MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjectStorage:objects
                                               count:count
                                                size:count]);
}


- (instancetype) mulleInitWithArray:(NSArray *) other
                              range:(NSRange) range
{
   NSUInteger               count;
   id                       *objects;

   MulleObjCValidateRangeWithLength( range, [other count]);

   count = range.length;
   if( ! count)
   {
      self = [self init];
      return( self);
   }

   objects   = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   [other getObjects:objects
               range:range];

   MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjectStorage:objects
                                               count:count
                                                size:count]);
}


- (instancetype) initWithArray:(NSArray *) other
                     copyItems:(BOOL) flag
{
   NSUInteger   count;
   id           *objects;

   count = [other count];
   if( ! count)
   {
      self = [self init];
      return( self);
   }

   objects   = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   [other getObjects:objects];

   if( flag)
      MulleObjCMakeObjectsPerformSelector( objects, count, @selector( copy), NULL);
   else
      MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjectStorage:objects
                                               count:count
                                                size:count]);
}


- (instancetype) initWithObject:(id) firstObject
                      arguments:(va_list) args
{
   va_list      copy;
   NSUInteger   count;
   id           *objects;
   id           *p;
   id           value;

   if( ! firstObject)
   {
      self = [self init];
      return( self);
   }

   va_copy( copy, args);

   count = 0;
   value = firstObject;
   while( value)
   {
      ++count;
      value = va_arg( copy, id);
   }
   va_end( copy);

   objects   = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   p         = objects;

   value = firstObject;
   while( value)
   {
      *p++  = value;
      value = va_arg( args, id);
   }

   MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjectStorage:objects
                                               count:count
                                                size:count]);
}


- (instancetype) initWithObject:(id) firstObject
                mulleVarargList:(mulle_vararg_list) args
{
   NSUInteger   count;
   id           *objects;
   id           *p;
   id           value;

   if( ! firstObject)
   {
      self = [self init];
      return( self);
   }

   count     = mulle_vararg_count_objects( args, firstObject);
   objects   = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   p         = objects;

   value = firstObject;
   while( value)
   {
      *p++  = value;
      value = mulle_vararg_next_id( args);
   }

   MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjectStorage:objects
                                               count:count
                                                size:count]);
}


- (instancetype) initWithObjects:(id) firstObject, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, firstObject);
   self = [self initWithObject:firstObject
               mulleVarargList:args];
   mulle_vararg_end( args);
   return( self);
}


- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
{
   if( ! count)
   {
      self = [self init];
      return( self);
   }

   if( count && ! objects)
      MulleObjCThrowInvalidArgumentException( @"emty objects with non-null count");
   MulleObjCMakeObjectsPerformRetain( objects, count);
   return( [self mulleInitWithRetainedObjects:objects
                                       count:count]);
}


- (instancetype) mulleInitWithArray:(NSArray *) other
                          andObject:(id) obj
{
   NSUInteger   count;
   id           *objects;

   count = [other count] + (obj != nil);
   if( ! count)
   {
      self = [self init];
      return( self);
   }

   objects = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   [other getObjects:objects];
   if( obj)
      objects[ count - 1] = obj;

   MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjectStorage:objects
                                               count:count
                                                size:count]);
}


- (instancetype) mulleInitWithArray:(NSArray *) other
                           andArray:(NSArray *) other2
{
   NSUInteger   count;
   NSUInteger   size;
   id           *objects;

   count = [other count];
   size  = [other2 count] + count;
   if( ! size)
      return( [self init]);

   objects = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * size);
   [other getObjects:objects];
   [other2 getObjects:&objects[ count]];

   MulleObjCMakeObjectsPerformRetain( objects, size);

   return( [self mulleInitWithRetainedObjectStorage:objects
                                              count:size
                                               size:size]);
}


typedef struct
{
   NSInteger   (*f)( id, id, void *);
   void        *ctxt;
} bouncy;


static int   bouncyBounce( void *a, void *b, void *_ctxt)
{
   bouncy  *ctxt;

   ctxt = _ctxt;
   return( (int) (ctxt->f)( (id) a, (id) b, ctxt->ctxt));
}


- (instancetype) mulleInitWithArray:(NSArray *) other
                       sortFunction:(NSInteger (*)( id, id, void *)) f
                            context:(void *) context
{
   NSUInteger   count;
   id           *objects;
   bouncy       bounce;

   count     = [other count];
   objects   = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   [other getObjects:objects];

   bounce.f    = f;
   bounce.ctxt = context;
   mulle_qsort_pointers( (void **) objects, count, bouncyBounce, &bounce);

   MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjectStorage:objects
                                               count:count
                                                size:count]);
}


static int   bouncyBounceSel( void *a, void *b, void *ctxt)
{
   return( (int) MulleObjCPerformSelector( (id) a, (SEL) ctxt, (id) b));
}


- (instancetype) mulleInitWithArray:(NSArray *) other
                   sortedBySelector:(SEL) sel
{
   NSUInteger   count;
   id           *objects;

   count = [other count];
   if( ! count)
   {
      self = [self init];
      return( self);
   }

   objects   = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * count);
   [other getObjects:objects];

   mulle_qsort_pointers( (void **) objects, count, bouncyBounceSel, (void *) (intptr_t) sel);

   MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjectStorage:objects
                                               count:count
                                                size:count]);
}


# pragma mark - construction conveniences


+ (instancetype) array
{
   return( [[[self alloc] init] autorelease]);
}


+ (instancetype) arrayWithArray:(NSArray *) other
{
   return( [[[self alloc] initWithArray:other] autorelease]);
}


+ (instancetype) mulleArrayWithArray:(NSArray *) other
                               range:(NSRange) range
{
   return( [[[self alloc] mulleInitWithArray:other
                                        range:range] autorelease]);
}


+ (instancetype) arrayWithObject:(id) obj
{
   return( [[[self alloc] initWithObjects:&obj
                                    count:obj ? 1 : 0] autorelease]);
}


+ (instancetype) arrayWithObjects:(id) firstObject, ...
{
   mulle_vararg_list   args;
   NSArray             *array;

   mulle_vararg_start( args, firstObject);
   array = [[[self alloc] initWithObject:firstObject
                         mulleVarargList:args] autorelease];
   mulle_vararg_end( args);

   return( array);
}


+ (instancetype) arrayWithObjects:(id *) objects
                            count:(NSUInteger) count
{
   return( [[[self alloc] initWithObjects:objects
                                    count:count] autorelease]);
}


+ (instancetype) mulleArrayWithRetainedObjects:(id *) objects
                                         count:(NSUInteger) count
{
   return( [[[self alloc] mulleInitWithRetainedObjects:objects
                                                 count:count] autorelease]);
}


# pragma mark - methods requiring construction

//
// could optimize the next two, by a subclass that just "stacks" arrays
// (would be cool, if both are immutable
//
- (NSArray *) arrayByAddingObject:(id) obj
{
   return( [[[NSArrayClass alloc] mulleInitWithArray:self
                                           andObject:obj] autorelease]);
}


- (NSArray *) arrayByAddingObjectsFromArray:(NSArray *) other
{
   return( [[[NSArrayClass alloc] mulleInitWithArray:self
                                           andArray:other] autorelease]);
}


- (NSArray *) sortedArrayUsingFunction:(NSInteger (*)(id, id, void *)) f
                               context:(void *) context
{
   if( ! f)
      MulleObjCThrowInvalidArgumentException( @"function is 0");

   return( [[[NSArrayClass alloc] mulleInitWithArray:self
                                        sortFunction:f
                                             context:context] autorelease]);
}


- (NSArray *) sortedArrayUsingSelector:(SEL) comparator
{
   if( ! comparator)
      MulleObjCThrowInvalidArgumentException( @"selector is 0");

   return( [[[NSArrayClass alloc] mulleInitWithArray:self
                                    sortedBySelector:comparator] autorelease]);
}


- (NSArray *) subarrayWithRange:(NSRange) range
{
   return( [[[NSArrayClass alloc] mulleInitWithArray:self
                                               range:range] autorelease]);
}


#pragma mark - NSCopying


// done by returning self in protocol already, NSMutableArray must override


# pragma mark -
# pragma mark xxx

- (id) firstObjectCommonWithArray:(NSArray *) other
{
   SEL   selContains;
   IMP   impContains;
   id    p;

   selContains = @selector( isEqual:);
   impContains = [other methodForSelector:selContains];

   for( p in self)
      if( (*impContains)( other, selContains, p))
         break;

   return( p);
}


static NSUInteger  findIndexWithRangeForEquality( NSArray *self, NSRange range, id obj)
{
   NSUInteger   len;
   id           buf[ 64];
   id           *p;
   id           *sentinel;
   BOOL         (*impEqual)( id, SEL, id);
   SEL          selEqual;

   selEqual = @selector( isEqual:);
   impEqual = (BOOL (*)(id, SEL, id)) [obj methodForSelector:selEqual];

   for(;;)
   {
      len = range.length > sizeof( buf) / sizeof( id)  ? sizeof( buf) / sizeof( id) : range.length;
      if( ! len)
         break;

      [self getObjects:buf
                 range:NSMakeRange( range.location, len)];
      sentinel = &buf[ len];

      for( p = buf; p < sentinel; p++, range.location++)
         if( (*impEqual)( obj, selEqual, *p))
            return( range.location);

      range.length -= len;
   }
   return( NSNotFound);
}


static NSUInteger  findIndexWithRange( NSArray *self, NSRange range, id obj)
{
   NSUInteger   len;
   id           buf[ 64];
   id           *p;
   id           *sentinel;

   for(;;)
   {
      len = range.length > sizeof( buf) / sizeof( id)  ? sizeof( buf) / sizeof( id) : range.length;
      if( ! len)
         break;

      [self getObjects:buf
                 range:NSMakeRange( range.location, len)];
      sentinel = &buf[ len];

      for( p = buf; p < sentinel; p++, range.location++)
         if( *p == obj)
            return( range.location);

      range.length -= len;
   }
   return( NSNotFound);
}


- (NSUInteger) indexOfObject:(id) obj
{
   return( findIndexWithRangeForEquality( self, NSMakeRange( 0, [self count]), obj));
}


- (BOOL) containsObject:(id) obj
{
   return( NSNotFound != findIndexWithRangeForEquality( self, NSMakeRange( 0, [self count]), obj));
}


- (NSUInteger) indexOfObject:(id) obj
                     inRange:(NSRange) range
{
   NSUInteger   count;

   count = [self count];
   MulleObjCValidateRangeWithLength( range, count);

   return( findIndexWithRangeForEquality( self, range, obj));
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
{
   return( findIndexWithRange( self, NSMakeRange( 0, [self count]), obj));
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
                                inRange:(NSRange) range
{
   NSUInteger   count;

   count = [self count];
   MulleObjCValidateRangeWithLength( range, count);

   return( findIndexWithRange( self, range, obj));
}


#pragma mark - hash and equality

- (NSUInteger) hash
{
   return( [[self lastObject] hash]);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSArray])
      return( NO);
   return( [self isEqualToArray:other]);
}


- (BOOL) isEqualToArray:(NSArray *) other
{
   NSUInteger     otherCount;
   NSUInteger     len;
   id             buf1[ 64];
   id             buf2[ 64];
   id             *sentinel;
   id             *p;
   id             *q;
   NSRange        range;

   range.length = [self count];
   otherCount   = [other count];

   if( range.length != otherCount)
      return( NO);

   range.location = 0;
   for(;;)
   {
      len = range.length > sizeof( buf1) / sizeof( id) ? sizeof( buf1) / sizeof( id) : range.length;
      if( ! len)
         break;

      [self getObjects:buf1
                 range:NSMakeRange( range.location, len)];
      [other getObjects:buf2
                  range:NSMakeRange( range.location, len)];

      sentinel = &buf1[ len];
      for( q = buf2, p = buf1; p < sentinel; p++, q++)
         if( ! [*p isEqual:*q])
            return( NO);

      range.location += len;
      range.length   -= len;
   }
   return( YES);
}


id   MulleForEachObjectCallFunction( id *objects,
                                     NSUInteger n,
                                     BOOL (*f)( id, void *),
                                     void *userInfo,
                                     enum MullePreempt preempt)
{
   id   *sentinel;

   sentinel = &objects[ n];
   switch( preempt)
   {
   case MullePreemptIfNotMatches :
         while( objects < sentinel)
         {
            if( ! (*f)( *objects, userInfo))
               return( *objects);
            ++objects;
         }
      break;

   case MullePreemptIfMatches :
      while( objects < sentinel)
         {
            if( (*f)( *objects, userInfo))
               return( *objects);
            ++objects;
         }
      break;

   default :
      while( objects < sentinel)
         (*f)( *objects++, userInfo);
   }
   return( nil);
}


//
// generic implementation
//
- (id) mulleForEachObjectCallFunction:(BOOL (*)( id, void *)) f
                             argument:(void *) argument
                              preempt:(enum MullePreempt) preempt
{
   id          buf[ 64];
   NSUInteger  n;
   NSUInteger  offset;
   NSUInteger  length;
   id          obj;

   offset = 0;
   length = [self count];
   while( length)
   {
      n = length >= 64 ? 64 : length;
      [self getObjects:buf
                 range:NSMakeRange( offset, n)];

      obj = MulleForEachObjectCallFunction( buf, n, f, argument, preempt);
      if( obj)
         return( obj);

      offset += n;
      length -= n;
   }
   return( nil);
}


#pragma mark - accessors

// need @alias for this
- (id) :(NSUInteger) i
{
   return( [self objectAtIndex:i]);
}


- (id) lastObject
{
   NSUInteger   i;

   i = [self count];
   if( ! i)
      return( nil);

   return( [self objectAtIndex:i - 1]);
}


static void   perform( NSArray *self, NSRange range, SEL sel, id obj)
{
   NSUInteger   len;
   id           buf[ 64];

   assert( range.location + range.length <= [self count]);

   for(;;)
   {
      len = range.length > sizeof( buf) / sizeof( id)
               ? sizeof( buf) / sizeof( id)
               : range.length;
      if( ! len)
         break;

      [self getObjects:buf
                 range:NSMakeRange( range.location, len)];

      MulleObjCMakeObjectsPerformSelector( buf, len, sel, obj);
      range.location += len;
      range.length   -= len;
   }
}

static void   perform2( NSArray *self, NSRange range, SEL sel, id obj, id obj2)
{
   NSUInteger   len;
   id           buf[ 64];

   assert( range.location + range.length <= [self count]);

   for(;;)
   {
      len = range.length > sizeof( buf) / sizeof( id)
               ? sizeof( buf) / sizeof( id)
               : range.length;
      if( ! len)
         break;

      [self getObjects:buf
                 range:NSMakeRange( range.location, len)];

      MulleObjCMakeObjectsPerformSelector2( buf, len, sel, obj, obj2);
      range.location += len;
      range.length   -= len;
   }
}



- (void) makeObjectsPerformSelector:(SEL) sel
{
   perform( self, NSMakeRange( 0, [self count]), sel, nil);
}


- (void) makeObjectsPerformSelector:(SEL) sel
                         withObject:(id) obj;
{
   perform( self, NSMakeRange( 0, [self count]), sel, obj);
}


- (void) mulleMakeObjectsPerformSelector:(SEL) sel
                              withObject:(id) obj
                              withObject:(id) obj2
{
   perform2( self, NSMakeRange( 0, [self count]), sel, obj, obj2);
}


- (void) _makeObjectsPerformSelector:(SEL) sel
                               range:(NSRange) range;
{
   perform( self, range, sel, nil);
}


#pragma mark - enumeration

- (NSEnumerator *) objectEnumerator
{
   return( [_MulleObjCArrayEnumerator enumeratorWithArray:self]);
}


- (NSEnumerator *) reverseObjectEnumerator
{
   return( [MulleObjCArrayReverseEnumerator enumeratorWithArray:self]);
}


# pragma mark - misc


- (BOOL) containsObject:(id) other
                inRange:(NSRange) range
{
   return( [self indexOfObject:other
                       inRange:range] != NSNotFound);
}


- (void) getObjects:(id *) objects
{
   [self getObjects:objects
              range:NSMakeRange( 0, [self count])];
}


#if DEBUG

- (instancetype) retain
{
   return( [super retain]);
}


- (instancetype) autorelease
{
   return( [super autorelease]);
}


- (void) release
{
   [super release];
}

#endif

@end

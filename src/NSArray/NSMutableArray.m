//
//  NSMutableArray.m
//  MulleObjCContainerFoundation
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
#import "NSMutableArray.h"

// other files in this library
#include "mulle-qsort-pointers.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies
#import "import-private.h"


@implementation NSObject( _NSMutableArray)

- (BOOL) __isNSMutableArray
{
   return( NO);
}

@end




@implementation NSMutableArray

static void   add_retained_object( NSMutableArray *self, id other);

- (BOOL) __isNSMutableArray
{
   return( YES);
}


// as we are "breaking out" of the class cluster, use standard
// allocation

#ifdef DEBUG
+ (Class) __classClusterClass
{
   abort();
}
#endif


- (id) mulleImmutableInstance
{
   return( [NSArray arrayWithArray:self]);
}


+ (instancetype) alloc
{
   return( NSAllocateObject( self, 0, NULL));
}


+ (instancetype) allocWithZone:(NSZone *) zone
{
   return( NSAllocateObject( self, 0, NULL));
}

// we could inherit new from NSArray safely, but while we are here
+ (instancetype) new
{
   return( [NSAllocateObject( self, 0, NULL) init]);
}


- (void) dealloc
{
   MulleObjCMakeObjectsPerformRelease( _storage, _count);
   MulleObjCInstanceDeallocateMemory( self, _storage);
   [super dealloc];
}


#pragma mark - init


- (instancetype) initWithCapacity:(NSUInteger) capacity
{
   if( capacity > self->_size)
   {
      self->_size    = capacity;
      self->_storage = MulleObjCInstanceReallocateNonZeroedMemory( self,
                                                                 self->_storage,
                                                                 sizeof( id) * self->_size);
   }
   return( self);
}


- (instancetype) mulleInitWithRetainedObjectStorage:(id *) storage
                                              count:(NSUInteger) count
                                               size:(NSUInteger) size
{
#ifndef NDEBUG
   {
      id  *p;
      id  *sentinel;

      p        = storage;
      sentinel = &p[ count];
      while( p < sentinel)
         assert( *p++);
   }
#endif

   self->_size    = size;
   self->_count   = count;
   self->_storage = storage;
   self->_mutationCount++;

   return( self);
}


static NSMutableArray  *initWithRetainedObjects( NSMutableArray *self,
                                                 id *objects,
                                                 NSUInteger count)
{
#ifndef NDEBUG
   {
      id  *p;
      id  *sentinel;

      p        = objects;
      sentinel = &p[ count];
      while( p < sentinel)
         assert( *p++);
   }
#endif
   assert( self->_storage == NULL);

   self->_size  = count;
   self->_count = count;
   if( count < 8)
      self->_size = 8;
   self->_storage = MulleObjCInstanceAllocateNonZeroedMemory( self,
                                                              sizeof( id) * self->_size);
   self->_mutationCount++;

   memcpy( self->_storage, objects, count * sizeof( id));
   return( self);
}


- (instancetype) mulleInitWithRetainedObjects:(id *) objects
                                        count:(NSUInteger) count
{
   return( initWithRetainedObjects( self, objects, count));
}


- (instancetype) mulleInitWithContainer:(id <NSFastEnumeration>) container
{
   id           *p;
   id           obj;
   NSUInteger   count;

   assert( self->_storage == NULL);

   count = [container count];

   self->_size  = count;
   self->_count = count;
   if( count < 8)
      self->_size = 8;
   self->_storage = MulleObjCInstanceAllocateNonZeroedMemory( self,
                                                              sizeof( id) * self->_size);
   self->_mutationCount++;

   p = self->_storage;
   for( obj in container)
      *p++ = [obj retain];
   assert( p == &self->_storage[ self->_count]);

   return( self);
}


- (instancetype) initWithObject:(id) object
                mulleVarargList:(mulle_vararg_list) args
{
   NSUInteger   count;
   id           p;

   count = mulle_vararg_count_ids( args, object);
   self  = [self initWithCapacity:count];

   p = object;
   while( p)
   {
      add_retained_object( self, [p retain]);
      p = mulle_vararg_next_id( args);
   }
   self->_mutationCount++;

   return( self);
}


- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) n
{
   MulleObjCMakeObjectsPerformRetain( objects, n);
   return( initWithRetainedObjects( self, objects, n));
}


#pragma mark - construction conveniences

+ (instancetype) arrayWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}



#pragma mark - methods

static void   reserve(  NSMutableArray *self, size_t count)
{
   if( self->_count + count >= self->_size)
   {
      if( count < self->_size)
         count = self->_size;
      if( count < 8)
         count += 8;
      self->_size += count;
      self->_storage = MulleObjCInstanceReallocateNonZeroedMemory( self,
                                                                   self->_storage,
                                                                   sizeof( id) * self->_size);
   }
}

//
// got no time, implement this "lamely" first
// do something cool later...
//
static void   add_retained_object( NSMutableArray *self, id other)
{
   if( ! other)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "object is nil");

   if( self->_count >= self->_size)
   {
      self->_size += self->_size;
      if( self->_size < 8)
         self->_size = 8;
      self->_storage = MulleObjCInstanceReallocateNonZeroedMemory( self,
                                                                   self->_storage,
                                                                   sizeof( id) * self->_size);
   }

   self->_storage[ self->_count++] = other;
   self->_mutationCount++;
}


- (void) addObject:(id) other
{
   add_retained_object( self, [other retain]);
}


- (void) mulleAddRetainedObject:(id) other
{
   add_retained_object( self, other);
}


- (NSUInteger) count
{
   return( _count);
}


static void  validate_index( NSMutableArray *self, NSUInteger i)
{
   if( i >= self->_count)
      MulleObjCThrowInvalidIndexException( i);
}


static void  validate_index_1( NSMutableArray *self, NSUInteger i)
{
   if( i >= self->_count + 1)
      MulleObjCThrowInvalidIndexException( i);
}


// need @alias for this
- (id) :(NSUInteger) i
{
   validate_index( self, i);
   return( _storage[ i]);
}


- (id) objectAtIndex:(NSUInteger) i
{
   validate_index( self, i);
   return( _storage[ i]);
}


static NSUInteger  indexOfObjectIdenticalTo( NSMutableArray *self,
                                             id obj,
                                             NSRange range)
{
   NSUInteger   i, n;

   n = range.length + range.location;
   for( i = range.location; i < n; i++)
      if( self->_storage[ i] == obj)
         return( i);

   return( NSNotFound);
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
{
   return( indexOfObjectIdenticalTo( self, obj, NSMakeRange( 0, self->_count)));
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
                                inRange:(NSRange) range
{
   range = MulleObjCValidateRangeAgainstLength( range, _count);

   return( indexOfObjectIdenticalTo( self, obj, range));
}


static NSUInteger
   indexOfObject( NSMutableArray *self, id obj, NSRange range, int pedantic)
{
   NSUInteger   i, n;
   BOOL         (*imp)( id, SEL, id);
   SEL          sel;

   // allow obj == nil
   if( ! obj || ! self->_count)
      return( NSNotFound);

   assert( [obj respondsToSelector:@selector( isEqual:)]);

   // quick check for first 32 pointers
   n = range.length;
   if( n > 32)
      n = 32;
   n += range.location;

   if( ! pedantic)
      for( i = range.location; i < n; i++)
         if( self->_storage[ i] == obj)
            return( i);

   sel = @selector( isEqual:);
   imp = (BOOL (*)( id, SEL, id)) [[obj self] methodForSelector:sel];  // resolve EOFault here

   n  = range.length + range.location;
   for( i = range.location; i < n; i++)
      if( (*imp)( obj, sel, self->_storage[ i]))
         return( i);

   return( NSNotFound);
}


- (BOOL) containsObject:(id) obj
{
   return( indexOfObject( self, obj, NSMakeRange( 0, self->_count), 0) != NSNotFound);
}


- (NSUInteger) indexOfObject:(id) obj
{
   return( indexOfObject( self, obj, NSMakeRange( 0, self->_count), 1));
}


- (NSUInteger) indexOfObject:(id) obj
                     inRange:(NSRange) range
{
   range = MulleObjCValidateRangeAgainstLength( range, _count);

   return( indexOfObject( self, obj, range, 1));
}


- (void) replaceObjectAtIndex:(NSUInteger) i
                   withObject:(id) object
{
   validate_index( self, i);

   [object retain];
   [_storage[ i] autorelease];

   _storage[ i] = object;
   _mutationCount++;
}


static void   removeObjectAtIndex( NSMutableArray *self,
                                   NSUInteger i)
{
   NSUInteger   n;

   validate_index( self, i);

   [self->_storage[ i] autorelease];

   n = self->_count - (i + 1);
   if( n)
      mulle_id_move( &self->_storage[ i], &self->_storage[ i + 1], n);
   --self->_count;
}


- (void) removeObjectAtIndex:(NSUInteger) i
{
   removeObjectAtIndex( self, i);

   _mutationCount++;
}


- (void) removeObject:(id) obj
{
   id     *p;
   id     *sentinel;
   SEL    sel;
   BOOL   (*imp)( id, SEL, id);

   if( ! obj)
      return;

   sel = @selector( isEqual:);
   imp = (BOOL (*)( id, SEL, id)) [[obj self] methodForSelector:sel];  // resolve EOFault here

   p        = &_storage[ _count];
   sentinel = &_storage[ 0];
   while( p > sentinel)
   {
      --p;
      if( *p == obj || (*imp)( obj, sel, *p))
         removeObjectAtIndex( self, p - _storage);
   }

   _mutationCount++;
}


- (void) removeObjectsInRange:(NSRange) range
{
   NSUInteger   n;

   if( ! range.length)
      return;

   validate_index( self, range.location);
   validate_index( self, range.location + range.length - 1);

   n = _count - (range.location + range.length - 1);
   if( n)
   {
      _MulleObjCAutoreleaseObjects( &_storage[ range.location],
                                    range.length,
                                    MulleObjCObjectGetUniverse( self));

      mulle_id_move( &_storage[ range.location],
                     &_storage[ range.location + range.length],
                     n);
   }
   _count -= range.length;
   _mutationCount++;
}


- (id) mulleRemoveLastObject
{
   id   obj;

   if( ! _count)
      return( nil);

   obj = [_storage[ --_count] autorelease];
   // dynamic shrinking
   if( _count < (_size >> 1) && _size > 8)
   {
      _size >>= 1;
      _storage = MulleObjCInstanceReallocateNonZeroedMemory( self,
                                                           _storage,
                                                           sizeof( id) * _size);
   }
   _mutationCount++;
   return( obj);
}


- (void) removeLastObject
{
   if( ! _count)
      MulleObjCThrowInvalidRangeException( NSMakeRange( 0, 0));

   [_storage[ --_count] autorelease];
   // dynamic shrinking
   if( _count < (_size >> 1) && _size > 8)
   {
      _size  >>= 1;
      _storage = MulleObjCInstanceReallocateNonZeroedMemory( self,
                                                           _storage,
                                                           sizeof( id) * _size);
   }
   _mutationCount++;
}


//
// idea: use a struct _mulle_autoreleasepointerarray as
// backing storage and just hand it en block over to the autorelease
// pool
//
- (void) removeAllObjects
{
   _MulleObjCAutoreleaseObjects( &_storage[ 0],
                                 _count,
                                 MulleObjCObjectGetUniverse( self));
   _count = 0;
   _mutationCount++;
}


- (void) removeObjectIdenticalTo:(id) obj
{
   NSUInteger   i;

   i = indexOfObjectIdenticalTo( self, obj, NSMakeRange( 0, self->_count));
   if( i != NSNotFound)
      [self removeObjectAtIndex:i];
}


- (void) removeObjectIdenticalTo:(id) obj
                         inRange:(NSRange) range
{
   NSUInteger   i;

   i = indexOfObjectIdenticalTo( self, obj, range);
   if( i != NSNotFound)
      [self removeObjectAtIndex:i];
}


#pragma mark - objects access

- (void) getObjects:(id *) aBuffer
{
   memcpy( aBuffer, self->_storage, self->_count * sizeof( id));
  // _mutationCount++;
}


- (void) getObjects:(id *) aBuffer
              range:(NSRange) range
{
   range = MulleObjCValidateRangeAgainstLength( range, _count);

   memcpy( aBuffer, &self->_storage[ range.location], range.length * sizeof( id));
}

//
// coded by example from http://cocoawithlove.com/2008/05/implementing-countbyenumeratingwithstat.html
//
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) state
                                   objects:(id *) stackbuf
                                     count:(NSUInteger) len
{
   if( state->state)
      return( 0);

   state->state        = 1;
   state->itemsPtr     = self->_storage;
   state->mutationsPtr = &_mutationCount;

   return( self->_count);
}


- (void) addObjectsFromArray:(NSArray *) array
{
   size_t   length;

   length = [array count];
   reserve( self, length);

   [array getObjects:&self->_storage[ self->_count]];

   MulleObjCMakeObjectsPerformRetain( &self->_storage[ self->_count], length);

   self->_count += length;

   _mutationCount++;
}


// it's primitive though the dox don't say it
- (void) replaceObjectsInRange:(NSRange) range
                   withObjects:(id *) objects
                         count:(NSUInteger) n
{
   NSUInteger  i;
   NSUInteger  j;

   assert( range.length == n);
   assert( objects);

   range = MulleObjCValidateRangeAgainstLength( range, _count);

   _MulleObjCAutoreleaseObjects( &_storage[ range.location],
                                 range.length,
                                 MulleObjCObjectGetUniverse( self));

   n  = range.length + range.location;
   for( j = 0, i = range.location; i < n; i++, j++)
      self->_storage[ i] = [objects[ i] retain];

   _mutationCount++;
}


- (void) replaceObjectsInRange:(NSRange) aRange
          withObjectsFromArray:(NSArray *) otherArray
{
   NSUInteger   n;

   n   = [otherArray count];
   mulle_flexarray_do_id( tmp, 16, n)
   {
      [otherArray getObjects:tmp];
      [self replaceObjectsInRange:aRange
                      withObjects:tmp
                            count:n];
   }
}


- (void) replaceObjectsInRange:(NSRange) aRange
          withObjectsFromArray:(NSArray *) otherArray
                         range:(NSRange) otherRange
{
   mulle_flexarray_do_id( tmp, 16, otherRange.length)
   {
      [otherArray getObjects:tmp
                       range:otherRange];
      [self replaceObjectsInRange:aRange
                      withObjects:tmp
                            count:otherRange.length];
   }
}


- (void) makeObjectsPerformSelector:(SEL) sel
{
   MulleObjCMakeObjectsPerformSelector0( _storage, _count, sel);
}


- (void) makeObjectsPerformSelector:(SEL) sel
                         withObject:(id) obj
{
   MulleObjCMakeObjectsPerformSelector( _storage, _count, sel, obj);
}


- (void) mulleMakeObjectsPerformSelector:(SEL) sel
                              withObject:(id) obj
                              withObject:(id) obj2
{
   MulleObjCMakeObjectsPerformSelector2( _storage, _count, sel, obj, obj2);
}


- (id) mulleForEachObjectCallFunction:(BOOL (*)( id, void *)) f
                             argument:(void *) userInfo
                              preempt:(enum MullePreempt) preempt
{
   return( MulleForEachObjectCallFunction( _storage, _count, f, userInfo, preempt));
}


- (void) setArray:(NSArray *) other
{
   [self removeAllObjects];
   [self addObjectsFromArray:other];
}


- (void) insertObject:(id) obj
              atIndex:(NSUInteger) i
{
   NSUInteger   n;

   validate_index_1( self, i);
   obj = [obj retain];
   if( i == self->_count)
   {
      add_retained_object( self, obj);
      return;
   }

   if( _count >= _size)
   {
      self->_size += self->_size;
      if( self->_size < 8)
         self->_size = 8;
      _storage = MulleObjCInstanceReallocateNonZeroedMemory( self, _storage, sizeof( id) * _size);
   }

   n = self->_count - i;
   mulle_id_move( &_storage[ i + 1], &_storage[ i], n);

   _storage[ i] = obj;
   self->_count++;
   _mutationCount++;
}


//
// implement some more NSMutableArray stuff
//
- (void) exchangeObjectAtIndex:(NSUInteger) index1
             withObjectAtIndex:(NSUInteger) index2
{
   id   tmp;

   validate_index( self, index1);
   validate_index( self, index2);

   tmp               = _storage[ index1];
   _storage[ index1] = _storage[ index2];
   _storage[ index2] = tmp;

   _mutationCount++;
}



- (void) mulleMoveObjectsInRange:(NSRange) range
                         toIndex:(NSUInteger) index
{
   NSInteger    offset;
   NSUInteger   s_length;
   NSUInteger   s_index;
   NSUInteger   d_index;
   NSUInteger   range_end;

   if( ! range.length)
      return;

   range     = MulleObjCValidateRangeAgainstLength( range, _count);
   validate_index( self, index);

   range_end = NSMaxRange( range);
   offset    = index - (intptr_t) range.location;

   //  |...I....R......R........|  #1#
   //  |...|ffff|rrrrrr|........|
   //  |...|rrrrrr|dddd|........|
   //
   //  |.........R..I...R.......|  #2#
   //  |.........|rrrrrr|ss|....|
   //  |.........|dd|rrrrrr|....|
   //
   //  |...R......R....I........|  #3#
   //  |...|rrrrrr|sssssssssss|.|
   //  |...|ddddddddddd|rrrrrr|.|
   //
   //  |.........R......R.......I  #5#
   //  |.........|rrrrrr|fffffff|
   //  |.........|fffffff|rrrrrr|

   // copy rest to tmp, keep range in array

   if( offset <= 0)
   {
      s_index  = index;          // #1#
      s_length = range.location - index;
      d_index  = index + range.length;
   }
   else
   {
      if( index + range.length > _count) 
         MulleObjCThrowInvalidIndexException( index);

      s_index  = range_end;   // #2#  && #3#
      s_length = index - range.location;
      d_index  = range.location;

      if( s_index + s_length > _count) // #4#
         s_length = _count - s_index;
   }

   if( s_length < range.length)
   {
      mulle_flexarray_do_id( tmp, 16, s_length)
      {
         mulle_id_copy( &tmp[ 0], &_storage[ s_index], s_length);
         mulle_id_move( &_storage[ index], &_storage[ range.location], range.length);
         mulle_id_move( &_storage[ d_index], tmp, s_length);
      }
      return;
   }

   mulle_flexarray_do_id( tmp, 16, range.length)
   {
      mulle_id_copy( &tmp[ 0], &_storage[ range.location], range.length);
      mulle_id_move( &_storage[ d_index], &_storage[ s_index], s_length);
      mulle_id_move( &_storage[ index], tmp, range.length);
   }
}


static int   bouncyBounceSel( void *a, void *b, void *ctxt)
{
   return( (int)(intptr_t) MulleObjCObjectPerformSelector( (id) a, (SEL)(intptr_t) ctxt, b));
}


- (void) sortUsingSelector:(SEL) sel
{
   mulle_qsort_pointers( (void **) _storage, _count, bouncyBounceSel, (void *) (uintptr_t) sel);
   _mutationCount++;
}


typedef struct
{
   NSComparisonResult   (*f)( id, id, void *);
   void                 *ctxt;
} bouncy;


static int   bouncyBounce( void *a, void *b, void *_ctxt)
{
   bouncy  *ctxt;

   ctxt = _ctxt;
   return( (int) (ctxt->f)( (id) a, (id) b, ctxt->ctxt));
}


- (void) sortUsingFunction:(NSComparisonResult (*)(id, id, void *)) f
                   context:(void *) context
{
   bouncy   bounce;

   bounce.ctxt = context;
   bounce.f    = f;

   mulle_qsort_pointers( (void **) _storage, _count, bouncyBounce, &bounce);
   _mutationCount++;
}


// reverses all objects
- (void) mulleReverseObjects
{
   NSUInteger     i, j, n;
   id             p, q;

   n = self->_count;
   if( ! n)
      return;

   for( i = 0, j = n - 1; i < j; i++, j--)
   {
      p = _storage[ i];
      q = _storage[ j];

      _storage[ j] = p;
      _storage[ i] = q;
   }
   _mutationCount++;
}



- (id) copy
{
   return( (id) [[NSArray alloc] initWithArray:self]);
}

@end


@implementation NSArray( NSMutableCopying)

- (id) mutableCopy
{
   return( [[NSMutableArray alloc] initWithArray:self]);
}

@end


@implementation NSArray( MulleMutableArrayAdditions)

- (NSArray *) mulleArrayByRemovingObject:(id) object
{
   NSMutableArray   *array;

   array = [NSMutableArray arrayWithArray:self];
   [array removeObject:object];
   return( array);
}

@end


//
//  _MulleObjCConcreteArray.m
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
#import "_MulleObjCConcreteArray.h"

// other files in this library
#include "mulle-qsort-pointers.h"

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"
#import "NSCoder.h"

// std-c and dependencies
#include <stdlib.h>

// private headers
#import "_MulleObjCConcreteArray-Private.h"

#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation _MulleObjCConcreteArray


Class  _MulleObjCConcreteArrayClass;


+ (void) load
{
   _MulleObjCConcreteArrayClass = self;
}


- (void) dealloc
{
   MulleObjCMakeObjectsPerformRelease( _objects, _count);
   if( _objects != _MulleObjCConcreteArrayGetInlineObjects( self))
      MulleObjCObjectDeallocateMemory( self, _objects);
   NSDeallocateObject( self);
}

#pragma mark - NSCoder support

- (instancetype) mulleInitWithCapacity:(NSUInteger) count
{
   return( _MulleObjCConcreteArrayNewWithCapacity( _MulleObjCConcreteArrayClass, count));
}


- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           *objects;
   id           *sentinel;
   id           *p;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   assert( count == _count);

   p        = _objects;
   sentinel = &p[ count];
   while( p < sentinel)
      [coder decodeValueOfObjCType:@encode( id)
                                at:p++];
}


#pragma mark - operations

static NSUInteger   findObject( _MulleObjCConcreteArray *self,
                                id obj,
                                BOOL (*f)( id, SEL, id), SEL sel)
{
   id           *sentinel;
   id           *p;
   NSUInteger   i;

   if( ! obj)
      return( NSNotFound);

   sentinel = &self->_objects[ self->_count];

   i = 0;
   if( f)
   {
      for( p = self->_objects; p < sentinel; p++, i++)
         if( (*f)( obj, sel, *p))
            return( i);
   }
   else
   {
      for( p = self->_objects; p < sentinel; p++, i++)
         if( obj == *p)
            return( i);
   }

   return( NSNotFound);
}


static NSUInteger   findObjectWithRange( _MulleObjCConcreteArray *self,
                                         NSRange range,
                                         id obj,
                                         BOOL (*f)( id, SEL, id), SEL sel)
{
   NSUInteger   sentinelLength;
   id           *sentinel;
   id           *p;
   NSUInteger   i;

   if( ! obj)
      return( NSNotFound);

   MulleObjCValidateRangeWithLength( range, self->_count);
   sentinelLength = range.location + range.length;

   sentinel = &self->_objects[ sentinelLength];
   i        = range.location;
   if( f)
   {
      for( p = &self->_objects[ range.location]; p < sentinel; p++, i++)
         if( (*f)( obj, sel, *p))
            return( i);
   }
   else
   {
      for( p = &self->_objects[ range.location]; p < sentinel; p++, i++)
         if( obj == *p)
            return( i);
   }

   return( NSNotFound);
}


- (NSUInteger) indexOfObject:(id) obj
{
   SEL    selEqual;
   BOOL   (*impEqual)( id, SEL, id);

   selEqual = @selector( isEqual:);
   impEqual = (BOOL (*)( id, SEL, id)) [obj methodForSelector:selEqual];
   return( findObject( self, obj, impEqual, selEqual));
}


- (NSUInteger) indexOfObject:(id) obj
                     inRange:(NSRange) range
{
   SEL     selEqual;
   BOOL    (*impEqual)( id, SEL, id);


   selEqual = @selector( isEqual:);
   impEqual = (BOOL (*)( id, SEL, id)) [obj methodForSelector:selEqual];
   return( findObjectWithRange( self, range, obj, impEqual, selEqual));
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
{
   return( findObject( self, obj, NULL, (SEL) 0));
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
                                inRange:(NSRange) range
{
   return( findObjectWithRange( self, range, obj, NULL, (SEL) 0));
}


- (id) lastObject
{
   if( ! _count)
      return( nil);

   return( _objects[_count - 1]);
}


- (void) makeObjectsPerformSelector:(SEL) sel
{
   MulleObjCMakeObjectsPerformSelector0( _objects, _count, sel);
}


- (void) makeObjectsPerformSelector:(SEL) sel
                         withObject:(id) obj
{
   MulleObjCMakeObjectsPerformSelector( _objects, _count, sel, obj);
}


- (void) mulleMakeObjectsPerformSelector:(SEL) sel
                              withObject:(id) obj
                              withObject:(id) obj2
{
   MulleObjCMakeObjectsPerformSelector2( _objects, _count, sel, obj, obj2);
}


- (id) mulleForEachObjectCallFunction:(BOOL (*)( id, void *)) f
                             argument:(void *) userInfo
                              preempt:(enum MullePreempt) preempt
{
   return( MulleForEachObjectCallFunction( _objects, _count, f, userInfo, preempt));
}


// need @alias for this
- (id) :(NSUInteger) i
{
   if( i >= _count)
      MulleObjCThrowInvalidIndexException( i);

   return( _objects[ i]);
}


- (id) objectAtIndex:(NSUInteger) i
{
   if( i >= _count)
      MulleObjCThrowInvalidIndexException( i);

   return( _objects[ i]);
}


- (NSUInteger) count
{
   return( _count);
}


- (void) getObjects:(id *) buf
              range:(NSRange) range
{
   if( range.location + range.length > _count || range.length > _count)
      MulleObjCThrowInvalidRangeException( range);

   memcpy( buf, &_objects[ range.location], sizeof( id) * range.length);
}


- (void) getObjects:(id *) buf
{
   memcpy( buf, _objects, sizeof( id) * _count);
}



//
// https://www.mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html
//
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) state
                                   objects:(id *) stackbuf
                                     count:(NSUInteger) len
{
   if( ! state->state)
   {
      state->mutationsPtr = (unsigned long *)self;
      state->itemsPtr     = _objects;
      state->state        = 1;
      return( self->_count);
   }
   return( 0);
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

//
//  _MulleObjCConcreteMutableOrderedSet.m
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
#import "_MulleObjCConcreteMutableOrderedSet.h"

// other files in this library
#import "NSArray.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies
#import "_MulleObjCOrderedSet-Private.h"

#include <assert.h>


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
#pragma clang diagnostic ignored "-Wprotocol"


@implementation _MulleObjCConcreteMutableOrderedSet


MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL_VAR
Class  _MulleObjCConcreteMutableOrderedSetClass;


+ (void) load
{
   _MulleObjCConcreteMutableOrderedSetClass = [self class];
}


- (void) addObject:(id) object
{
   _MulleObjCOrderedSetIvars   *ivars;
   struct mulle_allocator      *allocator;

   if( ! object)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "nil object");

   ivars     = _MulleObjCOrderedSetGetIvars( self);
   if( _mulle__map_get( &ivars->_table, object, NSOrderedSetCallback))
      return;

   allocator = MulleObjCInstanceGetAllocator( self);
   _mulle__map_set( &ivars->_table,
                    object,
                    object,
                    NSOrderedSetCallback,
                    allocator);
   _mulle__pointerarray_add( &ivars->_order,
                             object,
                             allocator);
}


- (void) addObjects:(id *) objects
              count:(NSUInteger) count
{
   NSUInteger   i;

   for( i = 0; i < count; i++)
      [self addObject:objects[ i]];
}


- (void) insertObject:(id) object
              atIndex:(NSUInteger) index
{
   _MulleObjCOrderedSetIvars   *ivars;
   struct mulle_allocator      *allocator;

   if( ! object)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "nil object");

   ivars = _MulleObjCOrderedSetGetIvars( self);
   if( index > _mulle__pointerarray_get_count( &ivars->_order))
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "index out of bounds");

   if( _mulle__map_get( &ivars->_table, object, NSOrderedSetCallback))
      return;

   allocator = MulleObjCInstanceGetAllocator( self);
   _mulle__map_set( &ivars->_table,
                    object,
                    object,
                    NSOrderedSetCallback,
                    allocator);
   _mulle__pointerarray_insert( &ivars->_order,
                                index,
                                object,
                                allocator);
}


- (void) insertObjects:(id *) objects
                 count:(NSUInteger) count
               atIndex:(NSUInteger) index
{
   NSUInteger   i;

   for( i = 0; i < count; i++)
      [self insertObject:objects[ i]
                 atIndex:index + i];
}


- (void) removeObject:(id) object
{
   NSUInteger   index;

   index = [self indexOfObject:object];
   if( index == NSNotFound)
      return;

   [self removeObjectAtIndex:index];
}


- (void) removeObjectAtIndex:(NSUInteger) index
{
   _MulleObjCOrderedSetIvars   *ivars;
   struct mulle_allocator      *allocator;
   id                          object;

   ivars = _MulleObjCOrderedSetGetIvars( self);
   if( index >= _mulle__pointerarray_get_count( &ivars->_order))
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "index out of bounds");

   object    = _mulle__pointerarray_get( &ivars->_order, index);
   allocator = MulleObjCInstanceGetAllocator( self);

   _mulle__pointerarray_remove_in_range( &ivars->_order,
                                         mulle_range_make( index, 1));
   _mulle__map_remove( &ivars->_table,
                        object,
                        NSOrderedSetCallback,
                        allocator);
}


- (void) removeAllObjects
{
   _MulleObjCOrderedSetIvars   *ivars;
   struct mulle_allocator      *allocator;

   ivars     = _MulleObjCOrderedSetGetIvars( self);
   allocator = MulleObjCInstanceGetAllocator( self);
   _mulle__map_reset( &ivars->_table,
                      NSOrderedSetCallback,
                      allocator);
   _mulle__pointerarray_reset( &ivars->_order);
}


- (void) replaceObjectAtIndex:(NSUInteger) index
                  withObject:(id) object
{
   _MulleObjCOrderedSetIvars   *ivars;
   struct mulle_allocator      *allocator;
   id                          old;

   if( ! object)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "nil object");

   ivars = _MulleObjCOrderedSetGetIvars( self);
   if( index >= _mulle__pointerarray_get_count( &ivars->_order))
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "index out of bounds");

   old = _mulle__pointerarray_get( &ivars->_order, index);
   if( [old isEqual:object])
      return;
   // Apple semantics: an object already in the set has no effect
   if( _mulle__map_get( &ivars->_table, object, NSOrderedSetCallback))
      return;

   allocator = MulleObjCInstanceGetAllocator( self);
   _mulle__map_remove( &ivars->_table,
                        old,
                        NSOrderedSetCallback,
                        allocator);
   _mulle__pointerarray_set( &ivars->_order, index, object);
   _mulle__map_set( &ivars->_table,
                    object,
                    object,
                    NSOrderedSetCallback,
                    allocator);
}

@end

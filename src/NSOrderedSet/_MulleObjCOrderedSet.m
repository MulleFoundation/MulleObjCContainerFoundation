//
//  _MulleObjCOrderedSet.m
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

#import "_MulleObjCOrderedSet.h"

// other files in this library
#import "NSEnumerator.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies

// private headers in this library
#import "_MulleObjCOrderedSet-Private.h"


@interface _MulleObjCOrderedSetEnumerator : NSEnumerator < NSEnumerator >
{
   id                                     _owner;
   struct mulle__pointerarrayenumerator   _rover;
}

- (instancetype) initWithOwner:(id) owner
                pointerarray:(struct mulle__pointerarray *) array;

@end


@implementation _MulleObjCOrderedSetEnumerator

- (instancetype) initWithOwner:(id) owner
                 pointerarray:(struct mulle__pointerarray *) array
{
   _owner = [owner retain];
   _rover = mulle__pointerarray_enumerate( array);
   return( self);
}


- (void) dealloc
{
   mulle__pointerarrayenumerator_done( &_rover);
   [_owner release];
   [super dealloc];
}


- (id) nextObject
{
   void   *object;

   if( mulle__pointerarrayenumerator_next( &_rover, &object))
      return( object);
   return( nil);
}

@end


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wprotocol"


@implementation  _MulleObjCOrderedSet


- (void) dealloc
{
   _MulleObjCOrderedSetFree( self);
}


- (NSUInteger) count
{
   _MulleObjCOrderedSetIvars   *ivars;

   ivars = _MulleObjCOrderedSetGetIvars( self);
   return( _mulle__map_get_count( &ivars->_table));
}


- (id) objectAtIndex:(NSUInteger) index
{
   _MulleObjCOrderedSetIvars   *ivars;

   ivars = _MulleObjCOrderedSetGetIvars( self);
   if( index >= _mulle__pointerarray_get_count( &ivars->_order))
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "index out of bounds");
   return( _mulle__pointerarray_get( &ivars->_order, index));
}


- (id) member:(id) object
{
   _MulleObjCOrderedSetIvars   *ivars;

   ivars = _MulleObjCOrderedSetGetIvars( self);
   return( _mulle__map_get( &ivars->_table, object, NSOrderedSetCallback));
}


- (NSEnumerator *) objectEnumerator
{
   _MulleObjCOrderedSetIvars   *ivars;

   ivars = _MulleObjCOrderedSetGetIvars( self);
   return( [[[_MulleObjCOrderedSetEnumerator alloc] initWithOwner:self
                                                    pointerarray:&ivars->_order] autorelease]);
}


- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) rover
                                   objects:(id *) buffer
                                     count:(NSUInteger) len
{
   _MulleObjCOrderedSetIvars   *ivars;
   void                        **storage;
   NSUInteger                  count;
   NSUInteger                  n;

   MULLE_C_UNUSED( buffer);

   ivars = _MulleObjCOrderedSetGetIvars( self);
   count = _mulle__pointerarray_get_count( &ivars->_order);
   if( rover->state >= count)
      return( 0);

   storage             = _mulle__pointerarray_get_storage( &ivars->_order);
   rover->itemsPtr     = (id *) &storage[ rover->state];
   rover->mutationsPtr = &ivars->_order._n_mutations;

   n = count - rover->state;
   if( n > len)
      n = len;
   rover->state += n;
   return( n);
}

@end

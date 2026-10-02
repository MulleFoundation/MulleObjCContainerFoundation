//
//  _NSOrderedSetPlaceholder.m
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

#import "_NSOrderedSetPlaceholder.h"

// other files in this library
#import "_MulleObjCEmptyOrderedSet.h"
#import "_MulleObjCConcreteOrderedSet.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies
#import "import-private.h"

// private headers in this library
#import "_MulleObjCOrderedSet-Private.h"

#include <assert.h>


//
// this is coupling the subclasses of _MulleObjCEmptyOrderedSet
// and _MulleObjCConcreteOrderedSet into the classcluster.
// NSMutableOrderedSet should never use the _NSOrderedSetPlaceholder.
//
@implementation _NSOrderedSetPlaceholder


# pragma mark - class cluster


- (instancetype) init
{
   self = [[_MulleObjCEmptyOrderedSetClass sharedInstance] retain];
   return( self);
}


//
// objects must have been allocated with MulleObjCInstanceGetAllocator( self)
// the size maybe larger but no less than count
//
- (instancetype) mulleInitWithRetainedObjectStorage:(id *) objects
                                              count:(NSUInteger) count
                                               size:(NSUInteger) size
{
   id   set;

   assert( size >= count);
   assert( objects || ! count);

   if( ! count)
      return( [[_MulleObjCEmptyOrderedSetClass sharedInstance] retain]);
   if( ! objects)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "NULL objects");

   set = _MulleObjCOrderedSetNewWithCapacity( _MulleObjCConcreteOrderedSetClass, count);
   set = (id) _MulleObjCOrderedSetInitWithRetainedObjectStorage( set, objects, count);
   return( (id) set);
}


- (instancetype) mulleInitWithRetainedObjects:(id *) objects
                                        count:(NSUInteger) count
{
   id   set;

   assert( objects || ! count);

   if( ! count)
      return( [[_MulleObjCEmptyOrderedSetClass sharedInstance] retain]);
   if( ! objects)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "NULL objects");

   set = _MulleObjCOrderedSetNewWithCapacity( _MulleObjCConcreteOrderedSetClass, count);
   set = (id) _MulleObjCOrderedSetInitWithRetainedObjects( set, objects, count);
   return( (id) set);
}

@end

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

#import "_NSArrayPlaceholder.h"

// other files in this library
#import "_MulleObjCEmptyArray.h"
#import "_MulleObjCConcreteArray.h"

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"

// std-c and dependencies

// private headers in this library
#import "_MulleObjCConcreteArray-Private.h"


//
// this is coupling the subclasses of _MulleObjCEmptyArray
// and _MulleObjCConcreteArray into the classcluster
// NSMutableArray should never use he _NSArrayPlaceholder
//
@implementation _NSArrayPlaceholder


# pragma mark -
# pragma mark class cluster

- (id) init
{
   return( (id) [[_MulleObjCEmptyArray sharedInstance] retain]);
}


- (id) mulleInitWithCapacity:(NSUInteger) count
{
   if( ! count)
      return( (id) [[_MulleObjCEmptyArray sharedInstance] retain]);

   return( (id) _MulleObjCConcreteArrayNewWithCapacity( _MulleObjCConcreteArrayClass, count));
}


- (id) mulleInitWithRetainedObjects:(id *) objects
                              count:(NSUInteger) count
{
   _MulleObjCConcreteArray   *array;

   if( ! count)
      return( (id) [[_MulleObjCEmptyArray sharedInstance] retain]);

   if( ! objects)
      MulleObjCThrowInvalidArgumentException( @"NULL objects");

   array = _MulleObjCConcreteArrayNewWithCapacity( _MulleObjCConcreteArrayClass, count);
   array = (id) _MulleObjCConcreteArrayInitWithRetainedObjects( array, objects, count);
   return( (id) array);
}


//
// objects must have been allocated with MulleObjCObjectGetAllocator( self)
// the size maybe larger but no less than count
//
- (id) mulleInitWithRetainedObjectStorage:(id *) objects
                                    count:(NSUInteger) count
                                     size:(NSUInteger) size
{
   _MulleObjCConcreteArray   *array;
   struct mulle_allocator    *allocator;

   assert( size >= count);

   if( ! count)
   {
      allocator = MulleObjCObjectGetAllocator( self);
      mulle_allocator_free( allocator, objects);

      return( (id) [[_MulleObjCEmptyArray sharedInstance] retain]);
   }

   if( ! objects)
      MulleObjCThrowInvalidArgumentException( @"NULL objects");

   array = _MulleObjCConcreteArrayNewWithCapacity( _MulleObjCConcreteArrayClass, 0);
   array = (id) _MulleObjCConcreteArrayInitWithRetainedObjectStorage( array, objects, count);
   return( (id) array);
}


- (NSString *) description
{
   return( @"_NSArrayPlaceholder");
}

@end

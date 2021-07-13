//
//  _NSMutableSetPlaceholder.m
//  MulleObjCContainerFoundation
//
//  Copyright (c) 2019 Nat! - Mulle kybernetiK.
//  Copyright (c) 2019 Codeon GmbH.
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

#import "_NSMutableSetPlaceholder.h"

// other files in this library
#import "_MulleObjCConcreteMutableSet.h"

// other libraries of MulleObjCContainerFoundation
#import "MulleObjCContainerObjectCallback.h"

// std-c and dependencies

// private headers in this library
#import "_MulleObjCSet-Private.h"


//
// this is coupling the subclasses of _MulleObjCEmptyArray
// and _MulleObjCConcreteArray into the classcluster
// NSMutableArray should never use he _NSArrayPlaceholder
//
@implementation _NSMutableSetPlaceholder


# pragma mark - class cluster

extern Class   _MulleObjCConcreteMutableSetClass;

- (instancetype) init
{
   _MulleObjCConcreteMutableSet   *set;

   set = (id) _MulleObjCSetNewWithCapacity( _MulleObjCConcreteMutableSetClass, 0);
   return( (id) set);
}


- (instancetype) initWithCapacity:(NSUInteger) count
{
   _MulleObjCConcreteMutableSet   *set;

   set = (id) _MulleObjCSetNewWithCapacity( _MulleObjCConcreteMutableSetClass, count);
   return( (id) set);
}


//
// objects must have been allocated with MulleObjCInstanceGetAllocator( self)
// the size maybe larger but no less than count
//
- (instancetype) mulleInitWithRetainedObjectStorage:(id *) objects
                                              count:(NSUInteger) count
                                               size:(NSUInteger) size
{
   _MulleObjCConcreteMutableSet   *set;

   assert( size >= count);
   assert( count);
   assert( objects);

   set = (id) _MulleObjCSetNewWithCapacity( _MulleObjCConcreteMutableSetClass, count);
   set = (id) _MulleObjCSetInitWithRetainedObjects( set, objects, count);
   MulleObjCInstanceDeallocateMemory( self, objects);
   return( (id) set);
}


- (instancetype) mulleInitWithRetainedObjects:(id *) objects
                                        count:(NSUInteger) count
{
   _MulleObjCConcreteMutableSet   *set;

   assert( count);
   assert( objects);

   set = (id) _MulleObjCSetNewWithCapacity( _MulleObjCConcreteMutableSetClass, count);
   set = (id) _MulleObjCSetInitWithRetainedObjects( set, objects, count);
   return( (id) set);
}

@end

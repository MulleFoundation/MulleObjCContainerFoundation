//
//  _NSSetPlaceholder.m
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

#import "_NSSetPlaceholder.h"

// other files in this library
#import "_MulleObjCEmptySet.h"
#import "_MulleObjCConcreteSet.h"

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"

// std-c and dependencies

// private headers in this library
#import "_MulleObjCSet-Private.h"


//
// this is coupling the subclasses of _MulleObjCEmptyArray
// and _MulleObjCConcreteArray into the classcluster
// NSMutableArray should never use he _NSArrayPlaceholder
//
@implementation _NSSetPlaceholder


# pragma mark -
# pragma mark class cluster


- (id) init
{
   self = [[_MulleObjCEmptySetClass sharedInstance] retain];
   return( self);
}


- (id) mulleInitWithCapacity:(NSUInteger) count
{
   _MulleObjCConcreteSet   *set;

   assert( count);

   set = (id) _MulleObjCSetNewWithCapacity( _MulleObjCConcreteSetClass, count);
   return( set);
}

//
// objects must have been allocated with MulleObjCObjectGetAllocator( self)
// the size maybe larger but no less than count
//
- (id) mulleInitWithRetainedObjectStorage:(id *) objects
                                    count:(NSUInteger) count
                                     size:(NSUInteger) size
{
   _MulleObjCConcreteSet   *set;

   assert( size >= count);
   assert( count);
   assert( objects);

   set = (id) _MulleObjCSetNewWithCapacity( _MulleObjCConcreteSetClass, count);
   set = (id) _MulleObjCSetInitWithRetainedObjectStorage( set, objects, count);
   return( set);
}


- (id) mulleInitWithRetainedObjects:(id *) objects
                              count:(NSUInteger) count
{
   _MulleObjCConcreteSet   *set;

   assert( count);
   assert( objects);

   set = (id) _MulleObjCSetNewWithCapacity( _MulleObjCConcreteSetClass, count);
   set = (id) _MulleObjCSetInitWithRetainedObjects( set, objects, count);
   return( set);
}


- (NSString *) description
{
   return( @"_NSSetPlaceholder");
}


@end

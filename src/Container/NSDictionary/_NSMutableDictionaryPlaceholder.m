//
//  _NSMutableDictionaryPlaceholder.m
//  MulleObjCStandardFoundation
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

#import "_NSMutableDictionaryPlaceholder.h"

// other files in this library
#import "_MulleObjCConcreteMutableDictionary.h"

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"

// std-c and dependencies

// private headers in this library
#import "_MulleObjCDictionary-Private.h"


//
// this is coupling the subclasses of _MulleObjCEmptyArray
// and _MulleObjCConcreteArray into the classcluster
// NSMutableArray should never use he _NSArrayPlaceholder
//
@implementation _NSMutableDictionaryPlaceholder


# pragma mark -
# pragma mark class cluster

extern Class   _MulleObjCConcreteMutableDictionaryClass;

- (instancetype) init
{
   self = _MulleObjCDictionaryNewWithCapacity( _MulleObjCConcreteMutableDictionaryClass, 0);
   return( self);
}


- (instancetype) mulleInitWithCapacity:(NSUInteger) count
{
   self = _MulleObjCDictionaryNewWithCapacity( _MulleObjCConcreteMutableDictionaryClass, count);
   return( self);
}

//
// objects must have been allocated with MulleObjCObjectGetAllocator( self)
// the size maybe larger but no less than count
//
- (id) mulleInitWithRetainedObjectKeyStorage:(id *) objects
                                       count:(NSUInteger) count
                                        size:(NSUInteger) size
{
   _MulleObjCConcreteMutableDictionary   *dict;

   assert( size >= count);
   assert( count);
   assert( objects);

   dict = _MulleObjCDictionaryNewWithCapacity( _MulleObjCConcreteMutableDictionaryClass, count);
   dict = (id) _MulleObjCDictionaryInitWithRetainedObjectsAndCopiedKeys( dict, objects, &objects[ count], count);
   MulleObjCObjectDeallocateMemory( self, objects);
   return( (id) dict);
}


- (id) mulleInitWithRetainedObjects:(id *) objects
                         copiedKeys:(id *) keys
                              count:(NSUInteger) count
{
   _MulleObjCConcreteMutableDictionary   *dict;

   assert( count);
   assert( objects);

   dict = _MulleObjCDictionaryNewWithCapacity( _MulleObjCConcreteMutableDictionaryClass, count);
   dict = (id) _MulleObjCDictionaryInitWithRetainedObjectsAndCopiedKeys( dict, objects, keys, count);
   return( dict);
}


- (NSString *) description
{
   return( @"_NSMutableDictionaryPlaceholder");
}

@end

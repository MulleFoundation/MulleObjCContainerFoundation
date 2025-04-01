//
//  _NSDictionaryPlaceholder.m
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
#pragma clang diagnostic ignored "-Wparentheses"

#import "_NSDictionaryPlaceholder.h"

// other files in this library
#import "_MulleObjCEmptyDictionary.h"
#import "_MulleObjCConcreteDictionary.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies
#import "import-private.h"

// private headers in this library
#import "_MulleObjCDictionary-Private.h"


//
// this is coupling the subclasses of _MulleObjCEmptyArray
// and _MulleObjCConcreteArray into the classcluster
// NSMutableArray should never use he _NSArrayPlaceholder
//
@implementation _NSDictionaryPlaceholder


# pragma mark - class cluster

MULLE_OBJC_DEPENDS_ON_CLASS( _MulleObjCEmptyDictionary);


- (id) init
{
   self = [[_MulleObjCEmptyDictionaryClass sharedInstance] retain];
   return( self);
}


//
// objects must have been allocated with MulleObjCInstanceGetAllocator( self)
// the size maybe larger but no less than count
//
- (id) mulleInitWithRetainedObjectKeyStorage:(id *) objects
                                       count:(NSUInteger) count
                                        size:(NSUInteger) size
{
   id   dict;

   assert( size >= count);
   assert( objects || ! count);

   if( ! count)
      return( [[_MulleObjCEmptyDictionaryClass sharedInstance] retain]);
   if( ! objects)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "NULL objects");

   dict = _MulleObjCDictionaryNewWithCapacity( _MulleObjCConcreteDictionaryClass, count);
   dict = (id) _MulleObjCDictionaryInitWithRetainedObjectsAndCopiedKeys( dict, objects, &objects[ count], count);
   MulleObjCInstanceDeallocateMemory( self, objects);
   return( dict);
}


- (id) mulleInitWithRetainedObjects:(id *) objects
                         copiedKeys:(id *) keys
                              count:(NSUInteger) count
{
   id   dict;

   assert( objects || ! count);

   if( ! count)
      return( [[_MulleObjCEmptyDictionaryClass sharedInstance] retain]);
   if( ! objects || ! keys)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "NULL objects or keys");

   dict = _MulleObjCDictionaryNewWithCapacity( _MulleObjCConcreteDictionaryClass, count);
   dict = (id) _MulleObjCDictionaryInitWithRetainedObjectsAndCopiedKeys( dict, objects, keys, count);
   return( dict);
}


- (id) mulleInitWithObjectContainer:(id <NSFastEnumeration>) objects
                       keyContainer:(id <NSFastEnumeration>) keys
{
   id           dict;
   NSUInteger   count;

   count = [objects count];
   if( ! count)
      return( [[_MulleObjCEmptyDictionaryClass sharedInstance] retain]);
   if( ! objects || ! keys)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "NULL objects or keys");

   dict = _MulleObjCDictionaryNewWithCapacity( _MulleObjCConcreteDictionaryClass, count);
   dict = (id) _MulleObjCDictionaryInitWithObjectAndKeyContainers( dict, objects, keys);
   return( dict);
}

@end

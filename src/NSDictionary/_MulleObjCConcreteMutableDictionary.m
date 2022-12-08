//
//  _MulleObjCConcreteMutableDictionary.m
//  MulleObjCContainerFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "_MulleObjCConcreteMutableDictionary.h"

// other files in this library

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies
#import "_MulleObjCDictionary-Private.h"

#include <assert.h>


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
#pragma clang diagnostic ignored "-Wprotocol"


@implementation _MulleObjCConcreteMutableDictionary


Class  _MulleObjCConcreteMutableDictionaryClass;


+ (void) load
{
   _MulleObjCConcreteMutableDictionaryClass = [self class];
}


- (void) setObject:(id) obj
            forKey:(id <NSCopying>) key
{
   _MulleObjCDictionaryIvars   *ivars;
   struct mulle_allocator      *allocator;

   assert( [(NSObject *) key respondsToSelector:@selector( copy)]);
   assert( [(NSObject *) key respondsToSelector:@selector( hash)]);
   assert( [(NSObject *) key respondsToSelector:@selector( isEqual:)]);
   assert( [obj respondsToSelector:@selector( retain)]);

   allocator = MulleObjCInstanceGetAllocator( self);
   ivars     = _MulleObjCDictionaryGetIvars( self);
   _mulle__map_set( &ivars->_table, key, obj, NSDictionaryCallback, allocator);
}


- (void) mulleSetRetainedObject:(id) obj
                         forKey:(id <NSCopying>) key
{
   _MulleObjCDictionaryIvars   *ivars;
   struct mulle_allocator      *allocator;

   assert( [(NSObject *) key respondsToSelector:@selector( copy)]);
   assert( [(NSObject *) key respondsToSelector:@selector( hash)]);
   assert( [(NSObject *) key respondsToSelector:@selector( isEqual:)]);
   assert( [obj respondsToSelector:@selector( retain)]);

   allocator = MulleObjCInstanceGetAllocator( self);
   ivars     = _MulleObjCDictionaryGetIvars( self);
   key       = [key copy];

   _mulle__map_set( &ivars->_table, key, obj, NSDictionaryAssignCallback, allocator);
}


- (void) mulleSetRetainedObject:(id) obj
                   forCopiedKey:(id <NSCopying>) key
{
   _MulleObjCDictionaryIvars   *ivars;
   struct mulle_allocator      *allocator;

   assert( [(NSObject *) key respondsToSelector:@selector( copy)]);
   assert( [(NSObject *) key respondsToSelector:@selector( hash)]);
   assert( [(NSObject *) key respondsToSelector:@selector( isEqual:)]);
   assert( [obj respondsToSelector:@selector( retain)]);

   allocator = MulleObjCInstanceGetAllocator( self);
   ivars     = _MulleObjCDictionaryGetIvars( self);
   _mulle__map_set( &ivars->_table, key, obj, NSDictionaryAssignCallback, allocator);
}


- (void) removeObjectForKey:(id) key
{
   _MulleObjCDictionaryIvars    *ivars;
   struct mulle_allocator       *allocator;

   allocator = MulleObjCInstanceGetAllocator( self);
   ivars     = _MulleObjCDictionaryGetIvars( self);
   _mulle__map_remove( &ivars->_table, key, NSDictionaryCallback, allocator);
}


- (void) removeAllObjects
{
   _MulleObjCDictionaryIvars    *ivars;
   struct mulle_allocator       *allocator;

   allocator = MulleObjCInstanceGetAllocator( self);
   ivars     = _MulleObjCDictionaryGetIvars( self);
   _mulle__map_reset( &ivars->_table, NSDictionaryCallback, allocator);
}

@end

//
//  _MulleObjCSet.m
//  MulleObjCFoundation
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

#import "_MulleObjCSet.h"

// other files in this library
#import "NSEnumerator.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


#pragma clang diagnostic ignored "-Wprotocol"


@interface _MulleObjCSetEnumerator : NSEnumerator
{
   _MulleObjCSet< NSObject>     *_owner;
   struct _mulle_setenumerator  _rover;
}

- (instancetype) initWithSet:(_MulleObjCSet<NSObject> *) set
                  _mulle_set:(struct _mulle_set *) _set;

@end


@implementation _MulleObjCSetEnumerator

- (instancetype) initWithSet:(_MulleObjCSet<NSObject> *) set
                  _mulle_set:(struct _mulle_set *) _set
{
   _owner = [set retain];
   _rover = _mulle_set_enumerate( _set, NSSetCallback);
   return( self);
}

- (void) dealloc

{
   _mulle_setenumerator_done( &_rover);

   [_owner release];
   [super dealloc];
}


- (id) nextObject
{
   return( _mulle_setenumerator_next( &_rover));
}

@end


@implementation _MulleObjCSet

static id    initWithObjects( _MulleObjCSet *self, id *objects, NSUInteger count, BOOL copyItems)
{
   _MulleObjCSetIvars   *ivars;

   ivars = getSetIvars( self);
   _mulle_set_init( &ivars->_table,
                  (unsigned int) count,
                  copyItems ? MulleObjCContainerObjectKeyCopyCallback
                  : MulleObjCContainerObjectKeyRetainCallback,
                  ivars->_allocator);

   while( count)
   {
      _mulle_set_set( &ivars->_table, *objects++, NSSetCallback, ivars->_allocator);
      --count;
   }
   return( self);
}


+ (instancetype) newWithObject:(id) firstObject
               mulleVarargList:(mulle_vararg_list) arguments
{
   NSUInteger           count;
   _MulleObjCSet        *obj;
   _MulleObjCSetIvars   *ivars;
   id                   nextObject;

   assert( firstObject);

   count = mulle_vararg_count_objects( arguments, firstObject);
   obj   = _MulleObjCNewSetWithCapacity( self, count);
   ivars = getSetIvars( obj);

   _mulle_set_set( &ivars->_table, firstObject, NSSetCallback, ivars->_allocator);
   while( nextObject = mulle_vararg_next_id( arguments))
      _mulle_set_set( &ivars->_table, nextObject, NSSetCallback, ivars->_allocator);

   return( obj);
}


+ (instancetype) _allocWithCapacity:(NSUInteger) count
{
   id   obj;

   obj = _MulleObjCNewSetWithCapacity( self, count);
   return( obj);
}


+ (instancetype) newWithObjects:(id *) objects
                          count:(NSUInteger) count
                      copyItems:(BOOL) copyItems
{
   id   obj;

   obj   = _MulleObjCNewSetWithCapacity( self, count);
   initWithObjects( obj, objects, count, copyItems);
   return( obj);
}


- (instancetype) _initWithObjects:(id *) objects
                            count:(NSUInteger) count
{
   return( initWithObjects( self, objects, count, NO));
}


- (void) dealloc
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   _mulle_set_done( &ivars->_table, NSSetCallback, ivars->_allocator);

   NSDeallocateObject( self);
}


- (NSEnumerator *) objectEnumerator
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   return( [[_MulleObjCSetEnumerator instantiate] initWithSet:(id) self
                                                    _mulle_set:&ivars->_table]);
}


- (BOOL) containsObject:(id) obj
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   return( _mulle_set_get( &ivars->_table, obj, NSSetCallback) != NULL);
}


- (id) member:(id) obj
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   return( _mulle_set_get( &ivars->_table, obj, NSSetCallback));
}


- (NSUInteger) count
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   return( _mulle_set_get_count( &ivars->_table));
}

@end

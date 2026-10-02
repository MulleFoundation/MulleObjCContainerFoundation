//
//  _MulleObjCOrderedSet-Private.h
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
#import "_MulleObjCOrderedSet.h"


static inline _MulleObjCOrderedSetIvars  *_MulleObjCOrderedSetGetIvars( id self)
{
   return( (_MulleObjCOrderedSetIvars *) self);
}


__attribute__((ns_returns_retained))
static inline id  _MulleObjCOrderedSetNewWithCapacity( Class cls, NSUInteger capacity)
{
   id                          set;
   _MulleObjCOrderedSetIvars   *ivars;
   struct mulle_allocator      *allocator;

   set       = NSAllocateObject( cls, 0, NULL);
   ivars     = _MulleObjCOrderedSetGetIvars( set);
   allocator = MulleObjCInstanceGetAllocator( set);
   _mulle__map_init( &ivars->_table,
                     capacity,
                     NSOrderedSetCallback,
                     allocator);
   _mulle__pointerarray_init( &ivars->_order,
                              capacity,
                              allocator);

   return( set);
}


static inline void   _MulleObjCOrderedSetFree( id self)
{
   _MulleObjCOrderedSetIvars   *ivars;
   struct mulle_allocator      *allocator;

   allocator = MulleObjCInstanceGetAllocator( self);
   ivars     = _MulleObjCOrderedSetGetIvars( self);
   _mulle__pointerarray_done( &ivars->_order,
                              allocator);
   _mulle__map_done( &ivars->_table,
                     NSOrderedSetCallback,
                     allocator);
   NSDeallocateObject( self);
}


//
// objects have been retained by the caller and the ownership is transfered
// to us. The map retains key and value though, so we give back the caller's
// reference with an autorelease.
//
static inline id
   _MulleObjCOrderedSetInitWithRetainedObjects( id self,
                                                id *objects,
                                                NSUInteger count)
{
   _MulleObjCOrderedSetIvars   *ivars;
   struct mulle_allocator      *allocator;
   id                          *sentinel;
   id                          object;

   allocator = MulleObjCInstanceGetAllocator( self);
   ivars     = _MulleObjCOrderedSetGetIvars( self);

   sentinel = &objects[ count];
   while( objects < sentinel)
   {
      object = *objects++;
      if( ! _mulle__map_get( &ivars->_table, object, NSOrderedSetCallback))
      {
         _mulle__map_set( &ivars->_table,
                          object,
                          object,
                          NSOrderedSetCallback,
                          allocator);
         _mulle__pointerarray_add( &ivars->_order,
                                   object,
                                   allocator);
      }
      [object autorelease];
   }

   return( self);
}


static inline id
   _MulleObjCOrderedSetInitWithRetainedObjectStorage( id self,
                                                      id *objects,
                                                      NSUInteger count)
{
   _MulleObjCOrderedSetInitWithRetainedObjects( self, objects, count);
   MulleObjCInstanceDeallocateMemory( self, objects);

   return( self);
}

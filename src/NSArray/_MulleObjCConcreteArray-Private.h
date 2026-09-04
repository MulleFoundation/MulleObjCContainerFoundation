//
//  _MulleObjCConcreteArray-Private.h
//  MulleObjCContainerFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
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
MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
Class   _MulleObjCConcreteArrayClass;


static inline id   *_MulleObjCConcreteArrayGetInlineObjects( _MulleObjCConcreteArray *_self)
{
   struct { @defs( _MulleObjCConcreteArray); }  *self = (void *) _self;
   return( (id *) (&self->_objects + 1));
}


__attribute__((ns_returns_retained))
static inline _MulleObjCConcreteArray  *
   _MulleObjCConcreteArrayAllocateWithCapacity( Class cls, NSUInteger count)
{
   return( NSAllocateObject( cls, count * sizeof( id), NULL));
}


__attribute__((ns_returns_retained))
static inline _MulleObjCConcreteArray  *
   _MulleObjCConcreteArrayNewForCoderWithCapacity( Class cls, NSUInteger count)
{
   _MulleObjCConcreteArray                      *_self;
   struct { @defs( _MulleObjCConcreteArray); }  *self;

   _self =  _MulleObjCConcreteArrayAllocateWithCapacity( cls, count);
   self  = (void *) _self;

   self->_count   = count;
   self->_objects = _MulleObjCConcreteArrayGetInlineObjects( _self);

   return( _self);
}



static inline _MulleObjCConcreteArray *
   _MulleObjCConcreteArrayNewWithContainer( Class cls,
                                            id <NSFastEnumeration> container)
{
   _MulleObjCConcreteArray                      *_self;
   struct { @defs( _MulleObjCConcreteArray); }  *self;
   id                                           *p;
   id                                           obj;
   NSUInteger                                   count;

   count = [container count];

   _self = _MulleObjCConcreteArrayAllocateWithCapacity( cls, count);
   self  = (void *) _self;

   self->_count   = count;
   self->_objects = _MulleObjCConcreteArrayGetInlineObjects( _self);

   p = self->_objects;
   for( obj in container)
      *p++ = [obj retain];
   return( _self);
}


static inline _MulleObjCConcreteArray *
   _MulleObjCConcreteArrayNewWithRetainedObjects( Class cls,
                                                  id *objects,
                                                  NSUInteger count)
{
   _MulleObjCConcreteArray                      *_self;
   struct { @defs( _MulleObjCConcreteArray); }  *self;

#ifndef NDEBUG
   {
      id  *p;
      id  *sentinel;

      p        = objects;
      sentinel = &p[ count];
      while( p < sentinel)
         assert( *p++);
   }
#endif

   _self = _MulleObjCConcreteArrayAllocateWithCapacity( cls, count);
   self  = (void *) _self;

   self->_count   = count;
   self->_objects = _MulleObjCConcreteArrayGetInlineObjects( _self);

   memcpy( self->_objects, objects, sizeof( id) * count);
   return( _self);
}


static inline _MulleObjCConcreteArray *
   _MulleObjCConcreteArrayNewWithRetainedObjectStorage( Class cls,
                                                        id *objects,
                                                        NSUInteger count)
{
   _MulleObjCConcreteArray                      *_self;
   struct { @defs( _MulleObjCConcreteArray); }  *self;

#ifndef NDEBUG
   {
      id  *p;
      id  *sentinel;

      p        = objects;
      sentinel = &p[ count];
      while( p < sentinel)
         assert( *p++);
   }
#endif

   _self = _MulleObjCConcreteArrayAllocateWithCapacity( cls, 0);
   self  = (void *) _self;

   self->_count   = count;
   self->_objects = objects;

   return( _self);
}


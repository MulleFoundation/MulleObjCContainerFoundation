//
//  _MulleObjCConcreteArray-Private.h
//  MulleObjCContainerFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
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


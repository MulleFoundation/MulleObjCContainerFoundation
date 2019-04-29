//
//  _MulleObjCConcreteArray-Private.h
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

extern Class   _MulleObjCConcreteArrayClass;


static inline id   *_MulleObjCConcreteArrayGetInlineObjects( _MulleObjCConcreteArray *_self)
{
   struct { @defs( _MulleObjCConcreteArray); }  *self = (void *) _self;
   return( (id *) (&self->_objects + 1));
}


__attribute__((ns_returns_retained))
static inline _MulleObjCConcreteArray  *
   _MulleObjCConcreteArrayNewWithCapacity( Class self, NSUInteger count)
{
   struct { @defs( _MulleObjCConcreteArray); }  *array;

   array = (void *) NSAllocateObject( self, count * sizeof( id), NULL);
   array->_count   = count;
   array->_objects = (id *) (&array->_objects + 1);  // inline data
   return( (_MulleObjCConcreteArray *) array);
}


static inline _MulleObjCConcreteArray *
   _MulleObjCConcreteArrayInitWithRetainedObjects( _MulleObjCConcreteArray *_self,
                                                   id *objects,
                                                   NSUInteger count)
{
   struct { @defs( _MulleObjCConcreteArray); }  *self = (void *) _self;

   id   *buffer;

   assert( self->_count == count);

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

   buffer   = _MulleObjCConcreteArrayGetInlineObjects( _self);
   memcpy( buffer, objects, sizeof( id) * count);
   return( _self);
}


static inline _MulleObjCConcreteArray *
   _MulleObjCConcreteArrayInitWithRetainedObjectStorage( _MulleObjCConcreteArray *_self,
                                                         id *objects,
                                                         NSUInteger count)
{
   struct { @defs( _MulleObjCConcreteArray); }  *self = (void *) _self;
   id   *buffer;

   assert( self->_count == 0);

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

   self->_count   = count;
   self->_objects = objects;

   return( _self);
}


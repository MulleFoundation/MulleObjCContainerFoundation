//
//  _MulleObjCConcreteSet-Private.h
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

static inline _MulleObjCSetIvars  *_MulleObjCSetGetIvars( id self)
{
   return( (_MulleObjCSetIvars *) self);
}


__attribute__((ns_returns_retained))
static inline _MulleObjCSet  *_MulleObjCSetNewWithCapacity( Class cls, NSUInteger count)
{
   _MulleObjCSet            *set;
   _MulleObjCSetIvars       *ivars;
   struct mulle_allocator   *allocator;

   set       = NSAllocateObject( cls, 0, NULL);
   ivars     = _MulleObjCSetGetIvars( set);
   allocator = MulleObjCObjectGetAllocator( set);
   _mulle_set_init( &ivars->_table,
                    (unsigned int)( count),
                    NSSetCallback,
                    allocator);

   return( set);
}



static inline void   _MulleObjCSetFree( id self)
{
   _MulleObjCSetIvars       *ivars;
   struct mulle_allocator   *allocator;

   allocator = MulleObjCObjectGetAllocator( self);
   ivars     = _MulleObjCSetGetIvars( self);
   _mulle_set_done( &ivars->_table,
                    NSSetCallback,
                    allocator);
   NSDeallocateObject( self);
}


static inline id
   _MulleObjCSetInitWithRetainedObjects( id <_MulleObjCSet> self,
                                         id *objects,
                                         NSUInteger count)
{
   _MulleObjCSetIvars          *ivars;
   struct mulle_allocator      *allocator;
   id                          *sentinel;

   allocator = MulleObjCObjectGetAllocator( self);
   ivars     = _MulleObjCSetGetIvars( self);
   sentinel  = &objects[ count];
   while( objects < sentinel)
      _mulle_set_set( &ivars->_table, *objects++, NSSetAssignCallback, allocator);

   return( self);
}


static inline id
   _MulleObjCSetInitWithRetainedObjectStorage( id <_MulleObjCSet> self,
                                               id *objects,
                                               NSUInteger count)
{
   _MulleObjCSetInitWithRetainedObjects( self, objects, count);
   MulleObjCObjectDeallocateMemory( self, objects);

   return( self);
}


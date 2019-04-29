//
//  _MulleObjCConcreteDictionary-Private.h
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//



static inline _MulleObjCDictionaryIvars  *_MulleObjCDictionaryGetIvars( id<_MulleObjCDictionary> self)
{
   return( (_MulleObjCDictionaryIvars *) self);
}


__attribute__((ns_returns_retained))
static inline id  _MulleObjCDictionaryNewWithCapacity( Class self, NSUInteger count)
{
   id<_MulleObjCDictionary>    dictionary;
   _MulleObjCDictionaryIvars   *ivars;
   struct mulle_allocator      *allocator;

   dictionary = NSAllocateObject( self, 0, NULL);
   allocator  = MulleObjCObjectGetAllocator( dictionary);

   ivars = _MulleObjCDictionaryGetIvars( dictionary);
   _mulle_map_init( &ivars->_table,
                    count,
                    NSDictionaryCallback,
                    allocator);

   return( dictionary);
}


static inline id
   _MulleObjCDictionaryInitWithRetainedObjectsAndCopiedKeys( id <_MulleObjCDictionary> self,
                                                             id *objects,
                                                             id *keys,
                                                             NSUInteger count)
{
   _MulleObjCDictionary        *dictionary;
   _MulleObjCDictionaryIvars   *ivars;
   struct mulle_allocator      *allocator;
   struct mulle_pointerpair    pair;
   id                          *sentinel;

   allocator = MulleObjCObjectGetAllocator( self);
   ivars     = _MulleObjCDictionaryGetIvars( self);

   sentinel = &keys[ count];
   while( keys < sentinel)
   {
      pair._value = *objects++;
      pair._key   = *keys++;
      assert( pair._value);
      assert( pair._key);

      _mulle_map_set( &ivars->_table, &pair, NSDictionaryAssignCallback, allocator);
   }

   return( self);
}



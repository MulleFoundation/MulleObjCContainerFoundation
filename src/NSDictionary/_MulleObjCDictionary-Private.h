//
//  _MulleObjCConcreteDictionary-Private.h
//  MulleObjCContainerFoundation
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
   allocator  = MulleObjCInstanceGetAllocator( dictionary);

   ivars = _MulleObjCDictionaryGetIvars( dictionary);
   _mulle__map_init( &ivars->_table,
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
   _MulleObjCDictionaryIvars   *ivars;
   struct mulle_allocator      *allocator;
   struct mulle_pointerpair    pair;
   id                          *sentinel;

   allocator = MulleObjCInstanceGetAllocator( self);
   ivars     = _MulleObjCDictionaryGetIvars( self);

   sentinel = &keys[ count];
   while( keys < sentinel)
   {
      pair.value = *objects++;
      pair.key   = *keys++;
      assert( pair.value);
      assert( pair.key);

      _mulle__map_set_pair( &ivars->_table,
                            &pair,
                            NSDictionaryAssignCallback,
                            allocator);
   }

   return( self);
}


static inline id
   _MulleObjCDictionaryInitWithObjectAndKeyContainers( id <_MulleObjCDictionary> self,
                                                       id <NSFastEnumeration> objectContainer,
                                                       id <NSFastEnumeration> keyContainer)
{
   _MulleObjCDictionaryIvars   *ivars;
   struct mulle_allocator      *allocator;
   struct mulle_pointerpair    pair;
   NSFastEnumerationState      keyRover;
   NSFastEnumerationState      objectRover;
   id                          keys[ 16];
   id                          objects[ 16];
   NSUInteger                  i, n, m;

   assert( [objectContainer count] == [keyContainer count]);

   allocator = MulleObjCInstanceGetAllocator( self);
   ivars     = _MulleObjCDictionaryGetIvars( self);

   for(;;)
   {
      m = [keyContainer countByEnumeratingWithState:&keyRover
                                            objects:keys
                                              count:16];
      n = [objectContainer countByEnumeratingWithState:&objectRover
                                               objects:objects
                                                 count:16];
      if( m < n)
         n = m;
      if( ! n)
        break;

      for( i = 0; i < n; i++)
      {
         pair.value = objects[ i];
         pair.key   = keys[ i];
         assert( pair.value);
         assert( pair.key);

         _mulle__map_set_pair( &ivars->_table, &pair, NSDictionaryCallback, allocator);
      }
   } 
   return( self);
}




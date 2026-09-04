//
//  _MulleObjCDictionary-Private.h
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
                            NSDictionaryAssignRetainedKeyAssignRetainedValueCallback,
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




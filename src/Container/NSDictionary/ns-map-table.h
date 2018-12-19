//
//  ns-map-table.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#ifndef ns_map_table_h__
#define ns_map_table_h__

#import "import.h"

//
// NSMapTable is pretty much mulle_map, but the callbacks are a local copy
//
typedef struct mulle_container_keycallback        NSMapTableKeyCallBacks;
typedef struct mulle_container_valuecallback      NSMapTableValueCallBacks;
typedef struct mulle_container_keyvaluecallback   NSMapTableCallBacks;
typedef struct _mulle_mapenumerator               NSMapEnumerator;


typedef struct
{
   struct _mulle_map                         _map;
   struct mulle_container_keyvaluecallback   _callback;
   struct mulle_allocator                    *_allocator;
} NSMapTable;


# pragma mark -
# pragma mark setup and tear down

NSMapTable   *_NSCreateMapTableWithAllocator( NSMapTableKeyCallBacks keyCallBacks,
                                              NSMapTableValueCallBacks valueCallBacks,
                                              NSUInteger capacity,
                                              struct mulle_allocator *allocator);

NSMapTable   *NSCreateMapTable( NSMapTableKeyCallBacks keyCallBacks,
                                NSMapTableValueCallBacks valueCallBacks,
                                NSUInteger capacity);

void   NSFreeMapTable( NSMapTable *table);

void   NSResetMapTable( NSMapTable *table);



# pragma mark -
# pragma mark petty accessors

static inline NSUInteger   NSCountMapTable( NSMapTable *table)
{
   return( (NSUInteger) _mulle_map_get_count( &table->_map));
}


# pragma mark -
# pragma mark operations

static inline void   *NSMapGet( NSMapTable *table, void *key)
{
   return( _mulle_map_get( &table->_map, key, &table->_callback));
}


static inline void   NSMapRemove( NSMapTable *table, void *key)
{
   _mulle_map_remove( &table->_map, key, &table->_callback, table->_allocator);
}


void   NSMapInsert( NSMapTable *table, void *key, void *value);
void   NSMapInsertKnownAbsent( NSMapTable *table, void *key, void *value);
void   *NSMapInsertIfAbsent( NSMapTable *table, void *key, void *value);


# pragma mark -
# pragma mark copying

NSMapTable   *NSCopyMapTable( NSMapTable *table);


# pragma mark -
# pragma mark compatibility

static inline NSMapTable   *NSCreateMapTableWithZone( NSMapTableKeyCallBacks keyCallBacks,
                                                     NSMapTableValueCallBacks valueCallBacks,
                                                     NSUInteger capacity,
                                                     NSZone *zone)
{
   return( NSCreateMapTable( keyCallBacks, valueCallBacks, capacity));
}


static inline NSMapTable   *NSCopyMapTableWithZone( NSMapTable *table, NSZone *zone)
{
   return( NSCopyMapTable( table));
}

# pragma mark -
# pragma mark enumeration

static inline NSMapEnumerator   NSEnumerateMapTable( NSMapTable *table)
{
   return( _mulle_map_enumerate( &table->_map, &table->_callback));
}


static inline BOOL    NSNextMapEnumeratorPair( NSMapEnumerator *rover, void **key, void **value)
{
   struct mulle_pointerpair   *pair;

   pair = _mulle_mapenumerator_next( rover);
   if( ! pair)
      return( NO);

   if( key)
      *key = pair->_key;
   if( value)
      *value = pair->_value;
   return( YES);
}


static inline void    NSEndMapTableEnumeration( NSMapEnumerator *rover)
{
   _mulle_mapenumerator_done( rover);
}

# pragma mark - harmless hacks

// since the callbacks are copied into NSMapTable, we can
// do this:
static inline void  _NSObjCMapTableSetValueRelease( NSMapTable *table,
                                                    void   (*release)( struct mulle_container_valuecallback *callback, void *p, struct mulle_allocator *allocator))
{
   table->_callback.valuecallback.release = release;
}


#endif

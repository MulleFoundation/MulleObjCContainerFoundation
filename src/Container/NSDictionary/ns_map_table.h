/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSMapTable.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef ns_map_table_h__
#define ns_map_table_h__
 
#include <MulleObjC/ns_objc.h>
#include <MulleObjC/ns_exception.h>
#include <mulle_container/mulle_container.h>


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


static inline void   NSMapInsert( NSMapTable *table, void *key, void *value)
{
   struct mulle_pointerpair   pair;
   
   if( key == table->_callback.keycallback.not_a_key_marker)
      mulle_objc_throw_invalid_argument_exception( "key is not a key marker (%p)", key);
   
   pair._key   = key;
   pair._value = value;
   
   _mulle_map_insert( &table->_map, &pair, &table->_callback, table->_allocator);
}


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

#pragma mark - 
#pragma mark Callbacks


#endif

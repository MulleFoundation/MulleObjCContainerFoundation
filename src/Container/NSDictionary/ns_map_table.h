/*
 *  MulleFoundation - A tiny Foundation replacement
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
   _MULLE_MAP_BASE;
   struct mulle_container_keyvaluecallback   _callback;
   struct mulle_allocator                    *_allocator;
} NSMapTable;


NSMapTable   *NSCreateMapTable( NSMapTableKeyCallBacks keyCallBacks, 
                                NSMapTableValueCallBacks valueCallBacks, 
                                NSUInteger capacity);

void   NSInitMapTable( NSMapTable *table,
                       NSMapTableKeyCallBacks *keyCallBacks,
                       NSMapTableValueCallBacks *valueCallBacks, 
                       NSUInteger capacity);
                       
static inline void    NSMapTableDone( NSMapTable *table)
{
   _mulle_map_done( (struct _mulle_map *) table, &table->_callback, table->_allocator);
}


static inline void   NSFreeMapTable( NSMapTable *table)
{
   _mulle_map_free( (struct _mulle_map *) table, &table->_callback, table->_allocator);
}


static inline NSMapTable   *NSCreateMapTableWithZone( NSMapTableKeyCallBacks keyCallBacks,
                                                      NSMapTableValueCallBacks valueCallBacks, 
                                                      NSUInteger capacity, 
                                                      NSZone *zone)
{  
   return( NSCreateMapTable( keyCallBacks, valueCallBacks, capacity));
}


static inline void   *NSMapGet( NSMapTable *table, void *key)
{
   return( _mulle_map_get( (struct _mulle_map *) table, key, &table->_callback));
}


static inline void   NSMapRemove( NSMapTable *table, void *key)
{
   _mulle_map_remove( (struct _mulle_map *) table, key, &table->_callback, table->_allocator);
}


static inline NSUInteger   NSCountMapTable( NSMapTable *table)
{
   return( (NSUInteger) _mulle_map_get_count( (struct _mulle_map *) table));
}


void   NSMapInsert( NSMapTable *table, void *key, void *value);
void   NSMapInsertKnownAbsent( NSMapTable *table, void *key, void *value);
void   *NSMapInsertIfAbsent( NSMapTable *table, void *key, void *value);

NSMapTable   *NSCopyMapTable( NSMapTable *table);


static inline NSMapTable   *NSCopyMapTableWithZone( NSMapTable *table, NSZone *zone)
{
   return( NSCopyMapTable( table));
}


static inline NSMapEnumerator   NSEnumerateMapTable( NSMapTable *table)
{
   return( _mulle_map_enumerate( (struct _mulle_map *) table, &table->_callback));
}


static inline BOOL    NSNextMapEnumeratorPair( NSMapEnumerator *rover, void **key, void **value)
{
   return( _mulle_mapenumerator_next( rover, key, value));
}


static inline void    NSEndMapTableEnumeration( NSMapEnumerator *rover)
{
   _mulle_mapenumerator_done( rover);
}


static inline void    NSResetMapTable( NSMapTable *table)
{
   NSMapTableDone( table);
   NSInitMapTable( table, &table->_callback.keycallback, &table->_callback.valuecallback, 0);
}


#define NSIntMapKeyCallBacks              (*(NSMapTableKeyCallBacks *) &mulle_container_keycallback_int)
#define NSIntegerMapKeyCallBacks          (*(NSMapTableKeyCallBacks *) &mulle_container_keycallback_intptr)
#define NSNonOwnedPointerMapKeyCallBacks  (*(NSMapTableKeyCallBacks *) &mulle_container_keycallback_nonowned_pointer)
#define NSOwnedPointerMapKeyCallBacks     (*(NSMapTableKeyCallBacks *) &mulle_container_keycallback_owned_pointer)

#define NSIntMapValueCallBacks              (*(NSMapTableValueCallBacks *) &mulle_container_valuecallback_int)
#define NSIntegerMapValueCallBacks          (*(NSMapTableValueCallBacks *) &mulle_container_valuecallback_intptr)
#define NSNonOwnedPointerMapValueCallBacks  (*(NSMapTableValueCallBacks *) &mulle_container_valuecallback_nonowned_pointer)
#define NSOwnedPointerMapValueCallBacks     (*(NSMapTableValueCallBacks *) &mulle_container_valuecallback_owned_pointer)

#endif

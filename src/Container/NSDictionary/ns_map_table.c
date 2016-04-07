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
#include "ns_map_table.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


void   NSInitMapTable( NSMapTable *table,
                       NSMapTableKeyCallBacks *keyCallBacks, 
                       NSMapTableValueCallBacks *valueCallBacks, 
                       NSUInteger capacity)
{
   struct mulle_container_keyvaluecallback   callback;
   
   callback.keycallback   = *keyCallBacks;
   callback.valuecallback = *valueCallBacks;
   
    _mulle_map_init( (struct _mulle_map *) table, capacity, &callback, MulleObjCAllocator());
}
                              

NSMapTable   *NSCreateMapTable( NSMapTableKeyCallBacks keyCallBacks, 
                                NSMapTableValueCallBacks valueCallBacks, 
                                NSUInteger capacity)
{
   NSMapTable   *table;
   
   table = MulleObjCAllocateMemory( sizeof( NSMapTable));
   NSInitMapTable( table, &keyCallBacks, &valueCallBacks, capacity);
   return( table);
}


void   NSMapInsert( NSMapTable *table, void *key, void *value)
{
   if( key == table->_callback.keycallback.not_a_key_marker)
      MulleObjCThrowInvalidArgumentException( "key is not a key marker (%p)", key);
    _mulle_map_insert( (struct _mulle_map *) table, key, value, &table->_callback, table->_allocator);
}


void   NSMapInsertKnownAbsent( NSMapTable *table, void *key, void *value)
{
   if( key == table->_callback.keycallback.not_a_key_marker)
      MulleObjCThrowInvalidArgumentException( "key is not a key marker (%p)", key);
   
   if(  _mulle_map_get( (struct _mulle_map *) table, key, &table->_callback))
      MulleObjCThrowInvalidArgumentException( "key is already present (%p)", key);
   
    _mulle_map_insert( (struct _mulle_map *) table, key, value, &table->_callback, table->_allocator);
}


void   *NSMapInsertIfAbsent( NSMapTable *table, void *key, void *value)
{
   void  *old;
   
   old =  _mulle_map_get( (struct _mulle_map *) table, key, &table->_callback);
   if( old)
      return( old);
   
    _mulle_map_insert( (struct _mulle_map *) table, key, value, &table->_callback, table->_allocator);
   return( NULL);
}



NSMapTable   *NSCopyMapTable( NSMapTable *table)
{
   NSMapTable   *other;
   extern void   __mulle_map_copy( struct _mulle_map *, struct _mulle_map *, struct mulle_container_keyvaluecallback *, struct mulle_allocator *);

   other = NSCreateMapTable( table->_callback.keycallback, table->_callback.valuecallback, 0);
   if( other)
      __mulle_map_copy( (struct _mulle_map *) other, (struct _mulle_map *) table, &table->_callback, table->_allocator);
   return( other);
}

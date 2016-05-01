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


#pragma mark -
#pragma mark setup and teardown

static void   _NSMapTableInitWithAllocator( NSMapTable *table,
                                            NSMapTableKeyCallBacks *keyCallBacks,
                                            NSMapTableValueCallBacks *valueCallBacks,
                                            NSUInteger capacity,
                                            struct mulle_allocator *allocator)
{
   table->_callback.keycallback   = *keyCallBacks;
   table->_callback.valuecallback = *valueCallBacks;
   table->_allocator              = allocator;
   
   _mulle_map_init( (struct _mulle_map *) table, capacity, &table->_callback, table->_allocator);
}


static void   NSMapTableInit( NSMapTable *table,
                              NSMapTableKeyCallBacks *keyCallBacks,
                              NSMapTableValueCallBacks *valueCallBacks,
                              NSUInteger capacity)
{
   table->_callback.keycallback   = *keyCallBacks;
   table->_callback.valuecallback = *valueCallBacks;
   table->_allocator              = MulleObjCAllocator();
   
   _mulle_map_init( (struct _mulle_map *) table, capacity, &table->_callback, table->_allocator);
}


static inline void    NSMapTableDone( NSMapTable *table)
{
   _mulle_map_done( (struct _mulle_map *) table, &table->_callback, table->_allocator);
}


void    NSResetMapTable( NSMapTable *table)
{
   NSMapTableDone( table);
   NSMapTableInit( table, &table->_callback.keycallback, &table->_callback.valuecallback, 0);
}



NSMapTable   *NSCreateMapTable( NSMapTableKeyCallBacks keyCallBacks, 
                                NSMapTableValueCallBacks valueCallBacks, 
                                NSUInteger capacity)
{
   NSMapTable   *table;
   
   table = MulleObjCAllocateMemory( sizeof( NSMapTable));
   NSMapTableInit( table, &keyCallBacks, &valueCallBacks, capacity);
   return( table);
}


NSMapTable   *_NSCreateMapTableWithAllocator( NSMapTableKeyCallBacks keyCallBacks,
                                              NSMapTableValueCallBacks valueCallBacks,
                                              NSUInteger capacity,
                                              struct mulle_allocator *allocator)
{
   NSMapTable   *table;
   
   table = MulleObjCAllocateMemory( sizeof( NSMapTable));
   _NSMapTableInitWithAllocator( table, &keyCallBacks, &valueCallBacks, capacity, allocator);
   return( table);
}


#pragma mark -
#pragma mark operations


void   NSMapInsertKnownAbsent( NSMapTable *table, void *key, void *value)
{
   struct _mulle_keyvaluepair   pair;
   
   if( key == table->_callback.keycallback.not_a_key_marker)
      mulle_objc_throw_invalid_argument_exception( "key is not a key marker (%p)", key);
   
   if(  _mulle_map_get( (struct _mulle_map *) table, key, &table->_callback))
      mulle_objc_throw_invalid_argument_exception( "key is already present (%p)", key);
   
   pair._key   = key;
   pair._value = value;
   
   _mulle_map_insert( (struct _mulle_map *) table, &pair, &table->_callback, table->_allocator);
}


void   *NSMapInsertIfAbsent( NSMapTable *table, void *key, void *value)
{
   struct _mulle_keyvaluepair   pair;
   void                         *old;
   
   old =  _mulle_map_get( (struct _mulle_map *) table, key, &table->_callback);
   if( old)
      return( old);
   
   pair._key   = key;
   pair._value = value;
   
   _mulle_map_insert( (struct _mulle_map *) table, &pair, &table->_callback, table->_allocator);
   return( NULL);
}

#pragma mark -
#pragma mark copying

NSMapTable   *NSCopyMapTable( NSMapTable *table)
{
   NSMapTable   *other;

   other = NSCreateMapTable( table->_callback.keycallback, table->_callback.valuecallback, 0);
   if( other)
      _mulle_map_copy_items( (struct _mulle_map *) other, (struct _mulle_map *) table, &table->_callback, table->_allocator);
   return( other);
}


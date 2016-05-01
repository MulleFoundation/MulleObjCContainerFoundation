/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSHashTable.c is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#include "ns_hash_table.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


NSHashTable   *NSCreateHashTable( NSHashTableCallBacks callBacks, NSUInteger capacity)
{
   NSHashTable   *table;
   
   table  = MulleObjCAllocateMemory( sizeof( NSHashTable));
   NSInitHashTable( table, &callBacks, capacity);
   return( table);
}


NSHashTable   *NSCopyHashTable( NSHashTable *table)
{
   NSHashTable   *clone;
   
   clone  = NSCreateHashTable( table->_callback, mulle_set_get_count( &table->_set));
   mulle_set_copy_items( &clone->_set,
                         &table->_set);

   return( clone);
}


void   NSHashInsert( NSHashTable *table, void *p)
{
   if( p == table->_callback.not_a_key_marker)
      MulleObjCThrowInvalidArgumentException( "key is not a key marker (%p)", p);
   mulle_set_set( &table->_set, p);
}


void   NSHashInsertKnownAbsent( NSHashTable *table, void *p)
{
   if( p == table->_callback.not_a_key_marker)
      MulleObjCThrowInvalidArgumentException( "key is not a key marker (%p)", p);
   
   if( mulle_set_get( &table->_set, p))
      MulleObjCThrowInvalidArgumentException( "key is already present (%p)", p);
   
   mulle_set_set( &table->_set, p);
}


void   *NSHashInsertIfAbsent( NSHashTable *table, void *p)
{
   void  *old;
   
   old = mulle_set_get( &table->_set, p);
   if( old)
      return( old);
   
   mulle_set_set( &table->_set, p);
   return( NULL);
}



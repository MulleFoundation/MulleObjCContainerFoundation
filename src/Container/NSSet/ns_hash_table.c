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




NSHashTable   *NSCreateHashTable( NSHashTableCallBacks callBacks, NSUInteger capacity)
{
   NSHashTable *table;
   
   table  = MulleObjCAllocateMemory( sizeof( NSHashTable));
   NSInitHashTable( table, &callBacks, capacity);
   return( table);
}


void   NSHashInsert( NSHashTable *table, void *p)
{
   if( p == table->_callback->not_a_key_marker)
      MulleObjCThrowInvalidArgumentException( "key is not a key marker (%p)", p);
   mulle_set_insert( table, p);
}


void   NSHashInsertKnownAbsent( NSHashTable *table, void *p)
{
   if( p == table->_callback->not_a_key_marker)
      MulleObjCThrowInvalidArgumentException( "key is not a key marker (%p)", p);
   
   if( mulle_set_get( table, p))
      MulleObjCThrowInvalidArgumentException( "key is already present (%p)", p);
   
   mulle_set_insert( table, p);
}


void   *NSHashInsertIfAbsent( NSHashTable *table, void *p)
{
   void  *old;
   
   old = mulle_set_get( table, p);
   if( old)
      return( old);
   
   mulle_set_insert( table, p);
   return( NULL);
}

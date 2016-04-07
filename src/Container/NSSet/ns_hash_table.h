/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSHashTable.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef ns_hash_table_h__
#define ns_hash_table_h__

#include <mulle_container/mulle_container.h>
#include <MulleObjC/ns_objc.h>

//
// NSHashTable is pretty much mulle_set
//
typedef struct mulle_container_keycallback        NSHashTableCallBacks;
typedef struct mulle_set                          NSHashTable;
typedef struct mulle_setenumerator                NSHashEnumerator;


NSHashTable   *NSCreateHashTable( NSHashTableCallBacks callBacks, NSUInteger capacity);

static inline void   NSInitHashTable( NSHashTable *table, NSHashTableCallBacks *callBacks, NSUInteger capacity)
{
   mulle_set_init( table, capacity, callBacks, MulleObjCAllocator());
}


static inline NSHashTable   *NSCreateHashTableWithZone( NSHashTableCallBacks callBacks, NSUInteger capacity, NSZone *zone)
{
   return( NSCreateHashTable( callBacks, capacity));
}


static inline void   NSDoneHashTable( NSHashTable *table)
{
   mulle_set_done( table);
}


static inline void   NSFreeHashTable( NSHashTable *table)
{
   mulle_set_free( table);
}


static inline void   NSResetHashTable( NSHashTable *table)
{
   mulle_set_reset( table);
}


static inline void   *NSHashGet( NSHashTable *table, void *p)
{
   return( mulle_set_get( table, p));
}


static inline void   NSHashRemove( NSHashTable *table, void *p)
{
   mulle_set_remove( table, p);
}


static inline NSUInteger   NSCountHashTable( NSHashTable *table)
{
   return( mulle_set_get_count( table));
}


static inline NSHashTable   *NSCopyHashTable( NSHashTable *table)
{
   return( mulle_set_copy( table));
}


static inline NSHashTable   *NSCopyHashTableWithZone( NSHashTable *table, NSZone *zone)
{
   return( NSCopyHashTable( table));
}


static inline NSHashEnumerator   NSEnumerateHashTable( NSHashTable *table)
{
   return( mulle_set_enumerate( table));
}


static inline void   *NSNextHashEnumeratorItem( NSHashEnumerator *rover)
{
   return( mulle_setenumerator_next( rover));
}


static inline void   NSEndHashTableEnumeration( NSHashEnumerator *rover)
{
   mulle_setenumerator_done( rover);
}


void   NSHashInsert( NSHashTable *table, void *p);
void   NSHashInsertKnownAbsent( NSHashTable *table, void *p);
void   *NSHashInsertIfAbsent( NSHashTable *table, void *p);


//MulleObjUTF8String *MulleObjUTF8StringFromHashTable( NSHashTable *table);
//MulleObjCArray *MulleObjCAllHashTableObjects( NSHashTable *table);

#define NSIntHashCallBacks              (*(NSHashTableCallBacks *) &mulle_container_keycallback_int)
#define NSIntegerHashCallBacks          (*(NSHashTableCallBacks *) &mulle_container_keycallback_intptr)
#define NSNonOwnedPointerHashCallBacks  (*(NSHashTableCallBacks *) &mulle_container_keycallback_nonowned_pointer)
#define NSOwnedPointerHashCallBacks     (*(NSHashTableCallBacks *) &mulle_container_keycallback_owned_pointer)


//extern NSHashTableCallBacks   MulleObjCNonRetainedObjectHashCallBacks;
//extern NSHashTableCallBacks   MulleObjCObjectHashCallBacks;
//extern NSHashTableCallBacks   MulleObjCOwnedObjectIdentityHashCallBacks;

#endif


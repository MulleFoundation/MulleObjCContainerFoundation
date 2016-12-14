//
//  ns_hash_table.h
//  MulleObjCFoundation
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
#ifndef ns_hash_table_h__
#define ns_hash_table_h__

#include <mulle_container/mulle_container.h>
#include <MulleObjC/ns_objc.h>


typedef struct mulle_container_keycallback        NSHashTableCallBacks;

//
// NSHashTable is pretty much mulle_set with a copy of the callbacks
//
typedef struct
{
   NSHashTableCallBacks   _callback;   // callbacks must be first (!) (for callbacks)
   struct mulle_set       _set;
} NSHashTable;

typedef struct mulle_setenumerator    NSHashEnumerator;


NSHashTable   *NSCreateHashTable( NSHashTableCallBacks callBacks, NSUInteger capacity);

static inline void   NSInitHashTable( NSHashTable *table, NSHashTableCallBacks *callBacks, NSUInteger capacity)
{
   table->_callback = *callBacks;
   mulle_set_init( &table->_set, (unsigned int) capacity, &table->_callback, &mulle_default_allocator);
}


static inline NSHashTable   *NSCreateHashTableWithZone( NSHashTableCallBacks callBacks, NSUInteger capacity, NSZone *zone)
{
   return( NSCreateHashTable( callBacks, capacity));
}


static inline void   NSDoneHashTable( NSHashTable *table)
{
   mulle_set_done( &table->_set);
}


static inline void   NSFreeHashTable( NSHashTable *table)
{
   mulle_set_destroy( &table->_set);
}


static inline void   NSResetHashTable( NSHashTable *table)
{
   mulle_set_reset( &table->_set);
}


static inline void   *NSHashGet( NSHashTable *table, void *p)
{
   return( mulle_set_get( &table->_set, p));
}


static inline void   NSHashRemove( NSHashTable *table, void *p)
{
   mulle_set_remove( &table->_set, p);
}


static inline NSUInteger   NSCountHashTable( NSHashTable *table)
{
   return( mulle_set_get_count( &table->_set));
}


NSHashTable   *NSCopyHashTable( NSHashTable *table);


static inline NSHashTable   *NSCopyHashTableWithZone( NSHashTable *table, NSZone *zone)
{
   return( NSCopyHashTable( table));
}


static inline NSHashEnumerator   NSEnumerateHashTable( NSHashTable *table)
{
   return( mulle_set_enumerate( &table->_set));
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

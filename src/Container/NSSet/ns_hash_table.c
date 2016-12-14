//
//  ns_hash_table.c
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
#include "ns_hash_table.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


NSHashTable   *NSCreateHashTable( NSHashTableCallBacks callBacks, NSUInteger capacity)
{
   NSHashTable   *table;
   
   table  = mulle_malloc( sizeof( NSHashTable));
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
   if( p == table->_callback.notakey)
      MulleObjCThrowInvalidArgumentException( "key is not a key marker (%p)", p);
   mulle_set_set( &table->_set, p);
}


void   NSHashInsertKnownAbsent( NSHashTable *table, void *p)
{
   if( p == table->_callback.notakey)
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

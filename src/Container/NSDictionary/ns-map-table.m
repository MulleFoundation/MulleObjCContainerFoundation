//
//  ns_map_table.c
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
#import "ns-map-table.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"

// std-c and dependencies



void   NSMapInsert( NSMapTable *table, void *key, void *value)
{
   struct mulle_pointerpair   pair;

   if( key == table->_callback.keycallback.notakey)
      MulleObjCThrowInvalidArgumentException( @"key is not a key marker (%p)", key);

   pair._key   = key;
   pair._value = value;

   _mulle_map_insert( &table->_map, &pair, &table->_callback, table->_allocator);
}



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

   _mulle_map_init( &table->_map, capacity, &table->_callback, table->_allocator);
}


void    NSResetMapTable( NSMapTable *table)
{
   _mulle_map_done( &table->_map, &table->_callback, table->_allocator);
   _NSMapTableInitWithAllocator( table, &table->_callback.keycallback, &table->_callback.valuecallback, 0, table->_allocator);
}


NSMapTable   *NSCreateMapTable( NSMapTableKeyCallBacks keyCallBacks,
                                NSMapTableValueCallBacks valueCallBacks,
                                NSUInteger capacity)
{
   NSMapTable   *table;

   table = mulle_malloc( sizeof( NSMapTable));
   _NSMapTableInitWithAllocator( table, &keyCallBacks, &valueCallBacks, capacity, &mulle_default_allocator);
   return( table);
}


NSMapTable   *_NSCreateMapTableWithAllocator( NSMapTableKeyCallBacks keyCallBacks,
                                              NSMapTableValueCallBacks valueCallBacks,
                                              NSUInteger capacity,
                                              struct mulle_allocator *allocator)
{
   NSMapTable   *table;

   table = mulle_allocator_malloc( allocator, sizeof( NSMapTable));
   _NSMapTableInitWithAllocator( table, &keyCallBacks, &valueCallBacks, capacity, allocator);
   return( table);
}


void   NSFreeMapTable( NSMapTable *table)
{
   if( table)
      _mulle_map_destroy( &table->_map, &table->_callback, table->_allocator);
}



#pragma mark -
#pragma mark operations


void   NSMapInsertKnownAbsent( NSMapTable *table, void *key, void *value)
{
   struct mulle_pointerpair   pair;

   if( key == table->_callback.keycallback.notakey)
      MulleObjCThrowInvalidArgumentException( @"key is not a key marker (%p)", key);

   if(  _mulle_map_get( &table->_map, key, &table->_callback))
      MulleObjCThrowInvalidArgumentException( @"key is already present (%p)", key);

   pair._key   = key;
   pair._value = value;

   _mulle_map_insert( &table->_map, &pair, &table->_callback, table->_allocator);
}


void   *NSMapInsertIfAbsent( NSMapTable *table, void *key, void *value)
{
   struct mulle_pointerpair   pair;
   void                       *old;

   old =  _mulle_map_get( &table->_map, key, &table->_callback);
   if( old)
      return( old);

   pair._key   = key;
   pair._value = value;

   _mulle_map_insert( &table->_map, &pair, &table->_callback, table->_allocator);
   return( NULL);
}

#pragma mark -
#pragma mark copying

NSMapTable   *NSCopyMapTable( NSMapTable *table)
{
   NSMapTable   *other;

   other = NSCreateMapTable( table->_callback.keycallback, table->_callback.valuecallback, 0);
   if( other)
      _mulle_map_copy_items( (struct _mulle_map *) other, &table->_map, &table->_callback, table->_allocator);
   return( other);
}

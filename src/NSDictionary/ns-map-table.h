//
//  ns-map-table.h
//  MulleObjCContainerFoundation
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
#ifndef ns_map_table_h__
#define ns_map_table_h__

#import "import.h"

//
// NSMapTable is pretty much mulle_map, but the callbacks are a local copy
// the main difference is the describe method! This used to return NSString
// not char *.
//
typedef struct mulle_container_keycallback        NSMapTableKeyCallBacks;
typedef struct mulle_container_valuecallback      NSMapTableValueCallBacks;
typedef struct mulle_container_keyvaluecallback   NSMapTableCallBacks;
typedef struct mulle__mapenumerator               NSMapEnumerator;


typedef struct
{
   struct mulle__map                         _map;
   struct mulle_container_keyvaluecallback   _callback;
   struct mulle_allocator                    *_allocator;
} NSMapTable;


# pragma mark - setup and tear down

MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
NSMapTable   *MulleObjCMapTableCreateWithAllocator( NSMapTableKeyCallBacks keyCallBacks,
                                              NSMapTableValueCallBacks valueCallBacks,
                                              NSUInteger capacity,
                                              struct mulle_allocator *allocator);

MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
NSMapTable   *MulleObjCMapTableCreate( NSMapTableKeyCallBacks keyCallBacks,
                                NSMapTableValueCallBacks valueCallBacks,
                                NSUInteger capacity);

MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
void   MulleObjCMapTableFree( NSMapTable *table);

MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
void   MulleObjCMapTableReset( NSMapTable *table);


static inline NSMapTable   *NSCreateMapTable( NSMapTableKeyCallBacks keyCallBacks,
                                              NSMapTableValueCallBacks valueCallBacks,
                                              NSUInteger capacity)
{
   return( MulleObjCMapTableCreate( keyCallBacks, valueCallBacks, capacity));
}


static inline void   NSFreeMapTable( NSMapTable *table)
{
   MulleObjCMapTableFree( table);
}


static inline void   NSResetMapTable( NSMapTable *table)
{
   MulleObjCMapTableReset( table);
}



# pragma mark - petty accessors

static inline NSUInteger   NSCountMapTable( NSMapTable *table)
{
   return( (NSUInteger) _mulle__map_get_count( &table->_map));
}


# pragma mark - operations

static inline void   *NSMapGet( NSMapTable *table, void *key)
{
   return( _mulle__map_get( &table->_map, key, &table->_callback));
}


static inline int   NSMapMember( NSMapTable *table,
                                 void *key,
                                 void **originalKey,
                                 void **value)
{
   struct mulle_pointerpair  pair;
   struct mulle_pointerpair  *p;

   p = _mulle__map_get_pair( &table->_map, key, &table->_callback, &pair);
   if( ! p)
   {
      if( originalKey)
         *originalKey = table->_callback.keycallback.notakey;
      if( value)
         *value = NULL;
      return( 0);
   }
   if( originalKey)
      *originalKey = p->key;
   if( value)
      *value = p->value;
   return( 1);
}


static inline void   NSMapRemove( NSMapTable *table, void *key)
{
   _mulle__map_remove( &table->_map, key, &table->_callback, table->_allocator);
}


MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
void   MulleObjCMapTableInsert( NSMapTable *table, void *key, void *value);

MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
void   MulleObjCMapTableInsertKnownAbsent( NSMapTable *table, void *key, void *value);

MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
void   *MulleObjCMapTableInsertIfAbsent( NSMapTable *table, void *key, void *value);


static inline void   NSMapInsert( NSMapTable *table, void *key, void *value)
{
   MulleObjCMapTableInsert( table, key, value);
}


static inline void   NSMapInsertKnownAbsent( NSMapTable *table, void *key, void *value)
{
   MulleObjCMapTableInsertKnownAbsent( table, key, value);
}


static inline void   *NSMapInsertIfAbsent( NSMapTable *table, void *key, void *value)
{
   return( MulleObjCMapTableInsertIfAbsent( table, key, value));
}


# pragma mark - copying

MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
NSMapTable   *MulleObjCMapTableCopy( NSMapTable *table);

static inline NSMapTable   *NSCopyMapTable( NSMapTable *table)
{
   return( MulleObjCMapTableCopy( table));
}

# pragma mark - compatibility

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

# pragma mark - enumeration

static inline NSMapEnumerator   NSEnumerateMapTable( NSMapTable *table)
{
   if( ! table)
      return( (NSMapEnumerator) { 0 });
   return( mulle__map_enumerate( &table->_map, &table->_callback));
}


static inline BOOL    NSNextMapEnumeratorPair( NSMapEnumerator *rover, void **key, void **value)
{
   struct mulle_pointerpair   *pair;

   pair = _mulle__mapenumerator_next_pair( rover);
   if( ! pair)
      return( NO);

   if( key)
      *key = pair->key;
   if( value)
      *value = pair->value;
   return( YES);
}


static inline void    NSEndMapTableEnumeration( NSMapEnumerator *rover)
{
   mulle__mapenumerator_done( rover);
}

# pragma mark - harmless hacks

// since the callbacks are copied into NSMapTable, we can
// do this:
static inline void  _NSObjCMapTableSetValueRelease( NSMapTable *table,
                                                    void   (*release)( struct mulle_container_valuecallback *callback, void *p, struct mulle_allocator *allocator))
{
   table->_callback.valuecallback.release = release;
}


// TODO: use these and kill code in MuleObjCStandardFoundation
// #define NSIntMapKeyCallBacks                   mulle_container_keycallback_int
// #define NSIntegerMapKeyCallBacks               mulle_container_keycallback_intptr
// #define NSNonOwnedPointerMapKeyCallBacks       mulle_container_keycallback_nonowned_pointer
// #define NSNonOwnedPointerOrNullMapKeyCallBacks mulle_container_keycallback_nonowned_pointer_or_null
// #define NSOwnedPointerMapKeyCallBacks          mulle_container_keycallback_owned_pointer
// 
// #define NSIntMapValueCallBacks                 mulle_container_valuecallback_int
// #define NSIntegerMapValueCallBacks             mulle_container_valuecallback_intptr
// #define NSNonOwnedPointerMapValueCallBacks     mulle_container_valuecallback_nonowned_pointer
// #define NSOwnedPointerMapValueCallBacks        mulle_container_valuecallback_owned_pointer


#define NSNonRetainedObjectMapKeyCallBacks     (*(struct mulle_container_keycallback *)   &_MulleObjCContainerAssignKeyCallback)
#define NSNonRetainedObjectMapValueCallBacks   (*(struct mulle_container_valuecallback *) &_MulleObjCContainerAssignValueCallback)

#define NSObjectMapKeyCallBacks                MulleObjCContainerCopyKeyCallback
#define NSObjectMapValueCallBacks              MulleObjCContainerRetainValueCallback


#define NSMapTableFor( name, key, value)                                                                     \
   assert( sizeof( key) == sizeof( void *));                                                                 \
   assert( sizeof( value) == sizeof( void *));                                                               \
   for( NSMapEnumerator                                                                                      \
           rover__ ## key ## __ ## value = NSEnumerateMapTable( name),                                       \
           *rover__  ## key ## __ ## value ## __i = (void *) 0;                                              \
        ! rover__  ## key ## __ ## value ## __i;                                                             \
        rover__ ## key ## __ ## value ## __i = (NSEndMapTableEnumeration( &rover__ ## key ## __ ## value),   \
                                              (void *) 1))                                                   \
      while( NSNextMapEnumeratorPair( &rover__ ## key ## __ ## value,                                        \
                                      (void **) &key,                                                        \
                                      (void **) &value))

#endif

//
//  _MulleObjCConcreteDictionary.m
//  MulleObjCFoundation
//
//  Created by Nat! on 05.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteDictionary.h"

// other files in this library
#import "MulleObjCContainerCallback.h"
#import "NSEnumerator.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies

#define NSDictionaryCallback           ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueRetainCallback)
#define NSDictionaryCopyValueCallback  ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueCopyCallback)



@interface _MulleObjCConcreteDictionaryKeyEnumerator : NSEnumerator
{
   struct _mulle_mapenumerator    _rover;
   _MulleObjCConcreteDictionary   *_owner;
}

+ (NSEnumerator *) enumeratorWithDictionary:(_MulleObjCConcreteDictionary *) owner
                                      table:(struct _mulle_map *) table;

@end


@interface _MulleObjCConcreteDictionaryObjectEnumerator : _MulleObjCConcreteDictionaryKeyEnumerator
@end


@implementation _MulleObjCConcreteDictionary


__attribute__((ns_returns_retained))
static inline _MulleObjCConcreteDictionary  *_MulleObjCNewConcreteDictionaryWithCapacity( Class self, NSUInteger count)
{
   _MulleObjCConcreteDictionary  *dictionary;
   
   dictionary = NSAllocateObject( self, 0, NULL);
   dictionary->_allocator = MulleObjCObjectGetAllocator( self);
   _mulle_map_init( &dictionary->_table,
                    count + (count >> 2), // leave 25% spare room
                    NSDictionaryCallback,
                    dictionary->_allocator);
   return( dictionary);
}


static void   _addEntriesFromDictionary( NSDictionary *other,
                                         struct _mulle_map *table,
                                         BOOL copyItems,
                                         struct mulle_allocator *allocator)
{
   NSEnumerator                             *rover;
   struct _mulle_keyvaluepair                pair;
   struct _mulle_keyvaluepair                (*impNext)( id, SEL, id);
   SEL                                       selNext;
   struct mulle_container_keyvaluecallback   *callback;

   callback = copyItems ? NSDictionaryCopyValueCallback
                        : NSDictionaryCallback;
      
   rover  = [other keyEnumerator];
   selNext = @selector( _nextKeyValuePair:);
   impNext = (void *) [rover methodForSelector:selNext];
   
   while( (pair = (*impNext)( rover, selNext, other))._key)
      _mulle_map_set( table, &pair, callback, allocator);
}


+ (instancetype) newWithDictionary:(id) other
{
   _MulleObjCConcreteDictionary   *dictionary;
   
   dictionary = _MulleObjCNewConcreteDictionaryWithCapacity( self, [other count]);
   _addEntriesFromDictionary( other, &dictionary->_table, NO, dictionary->_allocator);

   return( dictionary);
}


+ (instancetype) newWithObjects:(id *) obj
                        forKeys:(id *) key
                          count:(NSUInteger) count
{
   _MulleObjCConcreteDictionary   *dictionary;
   struct _mulle_keyvaluepair     pair;
   id                             *sentinel;
   
   
   dictionary = _MulleObjCNewConcreteDictionaryWithCapacity( self, count);
   
   sentinel = &key[ count];
   while( key < sentinel)
   {
      pair._key   = *key++;
      pair._value = *obj++;
      
      _mulle_map_set( &dictionary->_table,
                      &pair,
                      NSDictionaryCallback,
                      dictionary->_allocator);
   }
   return( dictionary);
}


+ (instancetype) newWithDictionary:(id) other
                         copyItems:(BOOL) copy
{
   _MulleObjCConcreteDictionary   *dictionary;
   
   dictionary = _MulleObjCNewConcreteDictionaryWithCapacity( self, [other count]);
   _addEntriesFromDictionary( other, &dictionary->_table, copy, dictionary->_allocator);

   return( dictionary);
}


+ (instancetype) newWithObject:(id) object
                     arguments:(mulle_vararg_list) args
{
   _MulleObjCConcreteDictionary   *dictionary;
   id       *buf;
   id       *keys;
   id       *sentinel;
   id       *tofree;
   id       *values;
   id       p;
   size_t   count;
   size_t   size;
   
   count = mulle_vararg_count( args, object);

   buf = tofree = NULL;
   if( count)
   {
      size = sizeof( id) * 2 * count;
      buf  = size <= 0x400 ? alloca( size) : (tofree = MulleObjCAllocateNonZeroedMemory( size));

      values   = buf;
      keys     = &buf[ count];
      sentinel = keys;
      
      p = object;
      do
      {
         *values++ = p;
         *keys++   = mulle_vararg_next_object( args, id);
         p         = mulle_vararg_next_object( args, id);
      }
      while( values < sentinel);
   }

   dictionary = [self newWithObjects:buf
                             forKeys:&buf[ count]
                               count:count];
   MulleObjCDeallocateMemory( tofree);
   
   return( dictionary);
}


- (void) dealloc
{
   _mulle_map_done( &self->_table,
                    NSDictionaryCallback,
                    self->_allocator);
   NSDeallocateObject( self);
}


/*
 * From here on, we know that we have a Hashtable
 */
- (id) objectForKey:(id) key
{
   uintptr_t   hash;
   
   hash = (NSDictionaryCallback->keycallback.hash)( &NSDictionaryCallback->keycallback, key);
   return( _mulle_map_get( &self->_table, key, NSDictionaryCallback));
}


- (NSEnumerator *) keyEnumerator
{
   return( [_MulleObjCConcreteDictionaryKeyEnumerator enumeratorWithDictionary:self
                                                                         table:&_table]);
}


- (NSEnumerator *) objectEnumerator
{
   return( [_MulleObjCConcreteDictionaryObjectEnumerator enumeratorWithDictionary:self
                                                                            table:&_table]);
}

- (NSUInteger) count
{
   return( _mulle_map_get_count( &_table));
}


@end



@implementation _MulleObjCConcreteDictionaryKeyEnumerator


+ (NSEnumerator *) enumeratorWithDictionary:(_MulleObjCConcreteDictionary *) owner
                                      table:(struct _mulle_map *) table
{
   _MulleObjCConcreteDictionaryKeyEnumerator   *obj;
   
   obj = NSAllocateObject( self, 0, NULL);

   obj->_rover = _mulle_map_enumerate( table, NSDictionaryCallback);
   obj->_owner = [owner retain];
   
   return( NSAutoreleaseObject( obj));
}


- (void) dealloc
{
   _mulle_mapenumerator_done( &_rover);
   [self->_owner release];

   NSDeallocateObject( self);
}


- (struct _mulle_keyvaluepair *) _nextKeyValuePair:(id) owner
{
   return( _mulle_mapenumerator_next( &_rover));
}


- (id) nextObject
{
   struct _mulle_keyvaluepair   *pair;
   
   pair = _mulle_mapenumerator_next( &_rover);
   return( pair ? pair->_key : nil);
}

@end


@implementation _MulleObjCConcreteDictionaryObjectEnumerator

- (id) nextObject
{
   struct _mulle_keyvaluepair *pair;
   
   pair = _mulle_mapenumerator_next( &_rover);
   return( pair ? pair->_value : nil);
}

@end

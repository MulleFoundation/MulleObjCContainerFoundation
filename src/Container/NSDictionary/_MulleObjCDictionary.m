//
//  _MulleObjCDictionary.m
//  MulleObjCFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "_MulleObjCDictionary.h"

// other files in this library
#import "NSEnumerator.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
#pragma clang diagnostic ignored "-Wprotocol"


@class _MulleObjCDictionary;

@interface _MulleObjCDictionaryKeyEnumerator : NSEnumerator
{
   struct _mulle_mapenumerator       _rover;
   _MulleObjCDictionary< NSObject>   *_owner;
}

+ (NSEnumerator *) enumeratorWithDictionary:(_MulleObjCDictionary *) owner
                                      table:(struct _mulle_map *) table;

@end


@interface _MulleObjCDictionaryObjectEnumerator : _MulleObjCDictionaryKeyEnumerator
@end




@implementation _MulleObjCDictionary

static void   _addEntriesFromDictionary( NSDictionary *other,
                                         struct _mulle_map *table,
                                         BOOL copyItems,
                                         struct mulle_allocator *allocator)
{
   NSEnumerator                              *rover;
   struct mulle_pointerpair                  *pair;
   struct mulle_pointerpair                  *(*impNext)( id, SEL, id);
   SEL                                       selNext;
   struct mulle_container_keyvaluecallback   *callback;

   callback = copyItems ? NSDictionaryCopyValueCallback
                        : NSDictionaryCallback;

   rover  = [other keyEnumerator];
   selNext = @selector( _nextKeyValuePair:);
   impNext = (struct mulle_pointerpair *(*)()) [rover methodForSelector:selNext];

   while( pair = (*impNext)( rover, selNext, other))
      _mulle_map_set( table, pair, callback, allocator);
}


+ (instancetype) new
{
   return( (id) _MulleObjCNewDictionaryWithCapacity( self, 0));
}


+ (instancetype) newWithDictionary:(id) other
{
   _MulleObjCDictionary        *dictionary;
   _MulleObjCDictionaryIvars   *ivars;

   dictionary = _MulleObjCNewDictionaryWithCapacity( self, [other count]);
   ivars      = getDictionaryIvars( dictionary);
   _addEntriesFromDictionary( other, &ivars->_table, NO, ivars->_allocator);

   return( dictionary);
}


static void   setObjectsAndKeys( _MulleObjCDictionary *self, id *objects, id *keys, NSUInteger count)
{
   _MulleObjCDictionaryIvars   *ivars;
   struct mulle_pointerpair    pair;
   id                          *sentinel;

   ivars = getDictionaryIvars( self);

   sentinel = &keys[ count];
   while( keys < sentinel)
   {
      pair._key   = *keys++;
      pair._value = *objects++;

      _mulle_map_set( &ivars->_table,
                      &pair,
                      NSDictionaryCallback,
                     ivars->_allocator);
   }
}


+ (instancetype) newWithObjects:(id *) objects
                        forKeys:(id *) keys
                          count:(NSUInteger) count
{
   _MulleObjCDictionary   *dictionary;

   dictionary = _MulleObjCNewDictionaryWithCapacity( self, count);
   setObjectsAndKeys( dictionary, objects, keys, count);
   return( dictionary);
}


+ (instancetype) newWithDictionary:(id) other
                         copyItems:(BOOL) copy
{
   _MulleObjCDictionary        *dictionary;
   _MulleObjCDictionaryIvars   *ivars;

   dictionary = _MulleObjCNewDictionaryWithCapacity( self, [other count]);
   ivars      = getDictionaryIvars( dictionary);
   _addEntriesFromDictionary( other, &ivars->_table, copy, ivars->_allocator);

   return( dictionary);
}


+ (instancetype) newWithObject:(id) object
               mulleVarargList:(mulle_vararg_list) args
{
   _MulleObjCDictionary   *dictionary;
   id                     *buf;
   id                     *keys;
   id                     *sentinel;
   id                     *tofree;
   id                     *values;
   id                     p;
   size_t                 count;
   size_t                 size;

   count = mulle_vararg_count_objects( args, object);

   buf = tofree = NULL;
   if( count)
   {
      id   _tmp[ 0x400];

      size = sizeof( id) * 2 * count;
      buf  = size <= 0x400 ? _tmp : (tofree = mulle_malloc( size));

      values   = buf;
      keys     = &buf[ count];
      sentinel = keys;

      p = object;
      do
      {
         *values++ = p;
         *keys++   = mulle_vararg_next_id( args);
         p         = mulle_vararg_next_id( args);
      }
      while( values < sentinel);
   }

   dictionary = [self newWithObjects:buf
                             forKeys:&buf[ count]
                               count:count];
   mulle_free( tofree);

   return( dictionary);
}


- (void) dealloc
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = getDictionaryIvars( self);
   _mulle_map_done( &ivars->_table,
                    NSDictionaryCallback,
                    ivars->_allocator);
   NSDeallocateObject( self);
}


#pragma mark -
#pragma mark NSCoder

+ (instancetype) _allocWithCapacity:(NSUInteger) count
{
   return( _MulleObjCNewDictionaryWithCapacity( self, count));
}


- (void) _setObjects:(id *) objects
                keys:(id *) keys
               count:(NSUInteger) count
{
   setObjectsAndKeys( self, objects, keys, count);
}


#pragma mark -
#pragma mark operations


- (id) :(id) key
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = getDictionaryIvars( self);
   return( _mulle_map_get( &ivars->_table, key, NSDictionaryCallback));
}


- (id) objectForKey:(id) key
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = getDictionaryIvars( self);
   return( _mulle_map_get( &ivars->_table, key, NSDictionaryCallback));
}


- (NSEnumerator *) keyEnumerator
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = getDictionaryIvars( self);
   return( [_MulleObjCDictionaryKeyEnumerator enumeratorWithDictionary:self
                                                                 table:&ivars->_table]);
}


- (NSEnumerator *) objectEnumerator
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = getDictionaryIvars( self);
   return( [_MulleObjCDictionaryObjectEnumerator enumeratorWithDictionary:self
                                                                    table:&ivars->_table]);
}

- (NSUInteger) count
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = getDictionaryIvars( self);
   return( _mulle_map_get_count( &ivars->_table));
}


@end


@implementation _MulleObjCDictionaryKeyEnumerator


+ (NSEnumerator *) enumeratorWithDictionary:(_MulleObjCDictionary< NSObject> *) owner
                                      table:(struct _mulle_map *) table
{
   _MulleObjCDictionaryKeyEnumerator   *obj;

   obj = NSAllocateObject( self, 0, NULL);

   obj->_rover = _mulle_map_enumerate( table, NSDictionaryCallback);
   obj->_owner = [owner retain];

   return( [obj autorelease]);
}


- (void) dealloc
{
   _mulle_mapenumerator_done( &_rover);
   [self->_owner release];

   NSDeallocateObject( self);
}


- (struct mulle_pointerpair *) _nextKeyValuePair:(id) owner
{
   return( _mulle_mapenumerator_next( &_rover));
}


- (id) nextObject
{
   struct mulle_pointerpair   *pair;

   pair = _mulle_mapenumerator_next( &_rover);
   return( pair ? pair->_key : nil);
}

@end


@implementation _MulleObjCDictionaryObjectEnumerator

- (id) nextObject
{
   struct mulle_pointerpair *pair;

   pair = _mulle_mapenumerator_next( &_rover);
   return( pair ? pair->_value : nil);
}

@end

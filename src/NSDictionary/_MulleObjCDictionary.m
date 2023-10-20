//
//  _MulleObjCDictionary.m
//  MulleObjCContainerFoundation
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
#pragma clang diagnostic ignored "-Wparentheses"

#import "_MulleObjCDictionary.h"

// other files in this library
#import "NSEnumerator.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies
#import "import-private.h"

// private files
#import "_MulleObjCDictionary-Private.h"


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wprotocol"



@interface _MulleObjCDictionaryKeyEnumerator : NSEnumerator
{
   struct mulle__mapenumerator       _rover;
   _MulleObjCDictionary< NSObject>   *_owner;
}

+ (NSEnumerator *) enumeratorWithDictionary:(_MulleObjCDictionary *) owner
                                      table:(struct mulle__map *) table;

@end


@interface _MulleObjCDictionaryObjectEnumerator : _MulleObjCDictionaryKeyEnumerator
@end


PROTOCOLCLASS_IMPLEMENTATION( _MulleObjCDictionary)

- (void) dealloc
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = _MulleObjCDictionaryGetIvars( self);
   _mulle__map_done( &ivars->_table,
                    NSDictionaryCallback,
                    MulleObjCInstanceGetAllocator( self));
   NSDeallocateObject( self);
}


#pragma mark - NSCoder

- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger                  count;
   struct mulle_pointerpair    pair;
   struct mulle_allocator      *allocator;
   _MulleObjCDictionaryIvars   *ivars;

   ivars     = _MulleObjCDictionaryGetIvars( self);
   allocator = MulleObjCInstanceGetAllocator( self);
   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   while( count)
   {
      [coder decodeValueOfObjCType:@encode( id)
                                at:&pair.value];
      [coder decodeValueOfObjCType:@encode( id)
                                at:&pair.key];
      if( ! pair.key || ! pair.value)
         MulleObjCThrowInvalidArgumentExceptionUTF8String( "nil key or value");

      _mulle__map_set_pair( &ivars->_table, &pair, NSDictionaryAssignRetainedKeyAssignRetainedValueCallback, allocator);
      --count;
   }
}


#pragma mark - operations

- (id) :(id) key
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = _MulleObjCDictionaryGetIvars( self);
   return( _mulle__map_get( &ivars->_table, key, NSDictionaryCallback));
}


- (id) objectForKey:(id) key
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = _MulleObjCDictionaryGetIvars( self);
   return( _mulle__map_get( &ivars->_table, key, NSDictionaryCallback));
}


- (NSEnumerator *) keyEnumerator
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = _MulleObjCDictionaryGetIvars( self);
   return( [_MulleObjCDictionaryKeyEnumerator enumeratorWithDictionary:self
                                                                 table:&ivars->_table]);
}


- (NSEnumerator *) objectEnumerator
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = _MulleObjCDictionaryGetIvars( self);
   return( [_MulleObjCDictionaryObjectEnumerator enumeratorWithDictionary:self
                                                                    table:&ivars->_table]);
}


- (NSUInteger) count
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = _MulleObjCDictionaryGetIvars( self);
   return( _mulle__map_get_count( &ivars->_table));
}


- (void) getObjects:(id *) objects
            andKeys:(id *) keys
              count:(NSUInteger) count
{
   id                             *sentinel;
   _MulleObjCDictionaryIvars      *ivars;
   struct mulle__mapenumerator    rover;
   struct mulle_pointerpair       *pair;

   ivars = _MulleObjCDictionaryGetIvars( self);
   if( count == (NSUInteger) -1)
      count = mulle__map_get_count( &ivars->_table);

   sentinel = &objects[ count];
   rover    = mulle__map_enumerate( &ivars->_table, NSDictionaryCallback);
   while( pair = _mulle__mapenumerator_next_pair( &rover))
   {
      if( objects >= sentinel)
         break;

      *objects++ = pair->value;
      *keys++    = pair->key;
   }
   mulle__mapenumerator_done( &rover);
}


- (id) mulleForEachObjectAndKeyCallFunction:(BOOL (*)( id, id, void *)) f
                                   argument:(void *) userInfo
                                    preempt:(enum MullePreempt) preempt
{
   _MulleObjCDictionaryIvars    *ivars;
   struct mulle__mapenumerator  rover;
   struct mulle_pointerpair     *pair;

   ivars = _MulleObjCDictionaryGetIvars( self);
   rover = mulle__map_enumerate( &ivars->_table, NSDictionaryCallback);

   switch( preempt)
   {
   case MullePreemptIfNotMatches :
      while( pair = _mulle__mapenumerator_next_pair( &rover))
         if( ! (*f)( pair->value,
                     pair->key,
                     userInfo))
         break;
      break;

   case MullePreemptIfMatches :
      while( pair = _mulle__mapenumerator_next_pair( &rover))
         if( (*f)( pair->value,
                   pair->key,
                   userInfo))
            break;
      break;

   default :
      while( pair = _mulle__mapenumerator_next_pair( &rover))
         (*f)( pair->value,
               pair->key,
               userInfo);
      break;
   }

   mulle__mapenumerator_done( &rover);
   return( pair ? pair->key : nil);
}



struct _MulleObjCDictionaryFastEnumerationState
{
   struct mulle__maptinyenumerator   _rover;
};


- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) rover
                                   objects:(id *) buffer
                                     count:(NSUInteger) len
{
   struct _MulleObjCDictionaryFastEnumerationState   *dstate;
   id                                                *sentinel;

   assert( sizeof( struct _MulleObjCDictionaryFastEnumerationState) <= sizeof( long) * 5);
   assert( alignof( struct _MulleObjCDictionaryFastEnumerationState) <= alignof( long));

   if( rover->state == -1)
      return( 0);

   // get our stat and init if its the first run
   dstate = (struct _MulleObjCDictionaryFastEnumerationState *) rover->extra;
   if( ! rover->state)
   {
      _MulleObjCDictionaryIvars   *ivars;

      ivars          = _MulleObjCDictionaryGetIvars( self);
      dstate->_rover = mulle__map_tinyenumerate_nil( &ivars->_table);
      rover->state   = 1;
   }

   rover->itemsPtr  = buffer;

   sentinel = &buffer[ len];
   while( buffer < sentinel)
   {
      if( ! _mulle__maptinyenumerator_next( &dstate->_rover, (void **) buffer, NULL))
      {
         rover->state = -1;
         mulle__maptinyenumerator_done( &dstate->_rover);
         break;
      }
      buffer++;
   }

   rover->mutationsPtr = &rover->extra[ 4];

   return( len - (sentinel - buffer));
}


- (NSInteger) mulleCountCollisions:(NSInteger *) perfects;
{
   _MulleObjCDictionaryIvars   *ivars;
   unsigned int                collisions;
   unsigned int                perfs;

   ivars      = _MulleObjCDictionaryGetIvars( self);
   collisions =  _mulle__map_count_collisions( &ivars->_table,
                                               NSDictionaryCallback,
                                               &perfs);
   if( perfects)
      *perfects = perfs;
   return( collisions);
}

PROTOCOLCLASS_END()


@implementation _MulleObjCDictionaryKeyEnumerator

+ (NSEnumerator *) enumeratorWithDictionary:(_MulleObjCDictionary< NSObject> *) owner
                                      table:(struct mulle__map *) table
{
   _MulleObjCDictionaryKeyEnumerator   *obj;

   assert( table);
   assert( owner);

// This is bad, we mutate something that should be immutable! This could
// make weird problem with  threads.
//   _mulle__map_shrink_if_needed( table, NSDictionaryCallback, allocator);
   obj         = NSAllocateObject( self, 0, NULL);
   obj->_rover = mulle__map_enumerate( table, NSDictionaryCallback);
   obj->_owner = [owner retain];

   return( [obj autorelease]);
}


- (void) dealloc
{
   mulle__mapenumerator_done( &_rover);
   [self->_owner release];

   NSDeallocateObject( self);
}


- (struct mulle_pointerpair *) _nextKeyValuePair:(id) owner
{
   return( _mulle__mapenumerator_next_pair( &_rover));
}


- (id) nextObject
{
   struct mulle_pointerpair   *pair;

   pair = _mulle__mapenumerator_next_pair( &_rover);
   return( pair ? pair->key : nil);
}

@end


@implementation _MulleObjCDictionaryObjectEnumerator

- (id) nextObject
{
   struct mulle_pointerpair *pair;

   pair = _mulle__mapenumerator_next_pair( &_rover);
   return( pair ? pair->value : nil);
}

@end


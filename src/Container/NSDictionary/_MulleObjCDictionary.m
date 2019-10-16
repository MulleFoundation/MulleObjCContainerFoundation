//
//  _MulleObjCDictionary.m
//  MulleObjCStandardFoundation
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

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"
#import "NSCoder.h"

// std-c and dependencies

// private files
#import "_MulleObjCDictionary-Private.h"


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
#pragma clang diagnostic ignored "-Wprotocol"
#pragma clang diagnostic ignored "-Wobjc-root-class"


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


PROTOCOLCLASS_IMPLEMENTATION( _MulleObjCDictionary)

- (void) dealloc
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = _MulleObjCDictionaryGetIvars( self);
   _mulle_map_done( &ivars->_table,
                    NSDictionaryCallback,
                    MulleObjCObjectGetAllocator( self));
   NSDeallocateObject( self);
}


#pragma mark -
#pragma mark NSCoder

- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger                  count;
   struct mulle_pointerpair    pair;
   struct mulle_allocator      *allocator;
   _MulleObjCDictionaryIvars   *ivars;

   ivars     = _MulleObjCDictionaryGetIvars( self);
   allocator = MulleObjCObjectGetAllocator( self);
   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   while( count)
   {
      [coder decodeValueOfObjCType:@encode( id)
                                at:&pair._value];
      [coder decodeValueOfObjCType:@encode( id)
                                at:&pair._key];
      if( ! pair._key || ! pair._value)
         MulleObjCThrowInvalidArgumentException( @"nil value");

      _mulle_map_set( &ivars->_table, &pair, NSDictionaryAssignCallback, allocator);
      --count;
   }
}


#pragma mark -
#pragma mark operations


- (id) :(id) key
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = _MulleObjCDictionaryGetIvars( self);
   return( _mulle_map_get( &ivars->_table, key, NSDictionaryCallback));
}


- (id) objectForKey:(id) key
{
   _MulleObjCDictionaryIvars   *ivars;

   ivars = _MulleObjCDictionaryGetIvars( self);
   return( _mulle_map_get( &ivars->_table, key, NSDictionaryCallback));
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
   return( _mulle_map_get_count( &ivars->_table));
}


- (void) getObjects:(id *) objects
            andKeys:(id *) keys
              count:(NSUInteger) count
{
   id                             *sentinel;
   _MulleObjCDictionaryIvars      *ivars;
   struct _mulle_mapenumerator    rover;
   struct mulle_pointerpair       *pair;

   ivars    = _MulleObjCDictionaryGetIvars( self);
   sentinel = &objects[ count];
   rover    = _mulle_map_enumerate( &ivars->_table, NSDictionaryCallback);
   while( pair = _mulle_mapenumerator_next( &rover))
   {
      if( objects >= sentinel)
         break;

      *objects++ = mulle_pointerpair_get_value( pair);
      *keys++    = mulle_pointerpair_get_key( pair);
   }
   _mulle_mapenumerator_done( &rover);
}


- (id) mulleForEachObjectAndKeyCallFunction:(BOOL (*)( id, id, void *)) f
                                   argument:(void *) userInfo
                                    preempt:(enum MullePreempt) preempt
{
   _MulleObjCDictionaryIvars      *ivars;
   struct _mulle_mapenumerator    rover;
   struct mulle_pointerpair       *pair;

   ivars = _MulleObjCDictionaryGetIvars( self);
   rover = _mulle_map_enumerate( &ivars->_table, NSDictionaryCallback);

   switch( preempt)
   {
   case MullePreemptIfNotMatches :
      while( pair = _mulle_mapenumerator_next( &rover))
         if( ! (*f)( mulle_pointerpair_get_value( pair),
                     mulle_pointerpair_get_key( pair),
                     userInfo))
         break;
      break;

   case MullePreemptIfMatches :
      while( pair = _mulle_mapenumerator_next( &rover))
         if( (*f)( mulle_pointerpair_get_value( pair),
                   mulle_pointerpair_get_key( pair),
                   userInfo))
            break;
      break;

   default :
      while( pair = _mulle_mapenumerator_next( &rover))
         (*f)( mulle_pointerpair_get_value( pair),
               mulle_pointerpair_get_key( pair),
               userInfo);
      break;
   }

   _mulle_mapenumerator_done( &rover);
   return( pair ? mulle_pointerpair_get_key( pair) : nil);
}



struct _MulleObjCDictionaryFastEnumerationState
{
   struct _mulle_maptinyenumerator   _rover;
};


- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) rover
                                   objects:(id *) buffer
                                     count:(NSUInteger) len
{
   struct _MulleObjCDictionaryFastEnumerationState   *dstate;
   struct mulle_pointerpair                          *pair;
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
      dstate->_rover = _mulle_map_tinyenumerate_nil( &ivars->_table);
      rover->state   = 1;
   }

   rover->itemsPtr  = buffer;

   sentinel = &buffer[ len];
   while( buffer < sentinel)
   {
      if( ! _mulle_maptinyenumerator_next( &dstate->_rover, (void **) buffer, NULL))
      {
         rover->state = -1;
         _mulle_maptinyenumerator_done( &dstate->_rover);
         break;
      }
      buffer++;
   }

   rover->mutationsPtr = &rover->extra[ 4];

   return( len - (sentinel - buffer));
}


PROTOCOLCLASS_END()



@implementation _MulleObjCDictionaryKeyEnumerator


+ (NSEnumerator *) enumeratorWithDictionary:(_MulleObjCDictionary< NSObject> *) owner
                                      table:(struct _mulle_map *) table
{
   _MulleObjCDictionaryKeyEnumerator   *obj;

   obj         = NSAllocateObject( self, 0, NULL);
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


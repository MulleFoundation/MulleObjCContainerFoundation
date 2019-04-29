//
//  NSDictionary.m
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
#pragma clang diagnostic ignored "-Wparentheses"

#import "NSDictionary.h"

// other files in this library
#import "_NSDictionaryPlaceholder.h"
#import "NSEnumerator.h"

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"
#import "NSAssertionHandler.h"


// std-c and dependencies


@implementation NSObject( _NSDictionary)

- (BOOL) __isNSDictionary
{
   return( NO);
}

@end


@implementation NSDictionary


- (BOOL) __isNSDictionary
{
   return( YES);
}


- (id) mulleImmutableInstance
{
   return( self);
}


#pragma mark -
#pragma mark class cluster


+ (Class) __placeholderClass
{
   return( [_NSDictionaryPlaceholder class]);
}


static id   initWithObjectKeyStorage( id self, id *storage, NSUInteger count, BOOL copyItems)
{
   // copy keys
   MulleObjCMakeObjectsPerformSelector( &storage[ count], count, @selector( copy), NULL);
   // retain or copy values
   if( copyItems)
      MulleObjCMakeObjectsPerformSelector( storage, count, @selector( copy), NULL);
   else
      MulleObjCMakeObjectsPerformRetain( storage, count);

   return( [self mulleInitWithRetainedObjectKeyStorage:storage
                                                 count:count
                                                  size:count]);
}


static id   initWithObjectsForKeys( id self, id *objects, id *keys, NSUInteger count, BOOL copyItems)
{
   // copy keys
   MulleObjCMakeObjectsPerformSelector( keys, count, @selector( copy), NULL);
   // retain or copy values
   if( copyItems)
      MulleObjCMakeObjectsPerformSelector( objects, count, @selector( copy), NULL);
   else
      MulleObjCMakeObjectsPerformRetain( objects, count);

   return( [self mulleInitWithRetainedObjects:objects
                                   copiedKeys:keys
                                        count:count]);
}



- (instancetype) initWithDictionary:(NSDictionary *) other
                          copyItems:(BOOL) copy
{
   NSUInteger   count;
   id           *storage;
   id           *objects;
   id           *keys;

   count = [other count];
   if( ! count)
      return( [self init]);

   storage = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * 2 * count);
   objects = storage;
   keys    = &storage[ count];

   [other getObjects:objects
             andKeys:keys
               count:count];

   return( initWithObjectKeyStorage( self, objects, count, copy));
}


- (instancetype) initWithDictionary:(NSDictionary *) other
{
   NSParameterAssert( ! other || [other __isNSDictionary]);

   self = [self initWithDictionary:other
                         copyItems:NO];
   return( self);
}



- (instancetype) initWithObject:(id) obj
                mulleVarargList:(mulle_vararg_list) args
{
   NSUInteger               count;
   NSUInteger               size;
   id                       *storage;
   id                       *values;
   id                       *keys;
   id                       key;
   id                       value;

   if( ! obj)
      return( [self init]);

   size = mulle_vararg_count_objects( args, obj);
   if( size & 1)
      MulleObjCThrowInvalidArgumentException( @"not even arguments");
   count   = size / 2;
   storage = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * size);
   values  = storage;
   keys    = &storage[ count];

   value = obj;
   while( value)
   {
      *values++  = value;
      *keys++    = mulle_vararg_next_id( args);
      value      = mulle_vararg_next_id( args);
   }

   return( initWithObjectKeyStorage( self, storage, count, NO));
}


- (instancetype) initWithObjectsAndKeys:(id) firstObject, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, firstObject);
   self = [self initWithObject:firstObject
               mulleVarargList:args];
   mulle_vararg_end( args);

   return( self);
}


- (instancetype) initWithObjects:(id *) objects
                         forKeys:(id *) keys
                           count:(NSUInteger) count
{
   if( ! count)
   {
      self = [self init];
      return( self);
   }

   if( ! objects || ! keys)
      MulleObjCThrowInvalidArgumentException( @"NULL objects");

   return( initWithObjectsForKeys( self, objects, keys, count, NO));
}


#pragma mark - creation conveniences

+ (instancetype) dictionary
{
   return( [[[self alloc] init] autorelease]);
}


+ (instancetype) dictionaryWithDictionary:(NSDictionary *) other
{
   return( [[[self alloc] initWithDictionary:other
                                   copyItems:NO] autorelease]);
}


+ (instancetype) dictionaryWithObject:(id) obj
                               forKey:(id) key
{
   return( [[[self alloc] initWithObjects:&obj
                                  forKeys:&key
                                    count:1] autorelease]);
}


+ (instancetype) dictionaryWithObjectsAndKeys:(id) object, ...
{
   NSDictionary        *dictionary;
   mulle_vararg_list   args;

   mulle_vararg_start( args, object);

   dictionary = [[[self alloc] initWithObject:object
                              mulleVarargList:args] autorelease];
   mulle_vararg_end( args);
   return( dictionary);
}


//
// should also work for NSMutableArray
//
+ (instancetype) dictionaryWithObjects:(id *) objects
                               forKeys:(id *) keys
                                count:(NSUInteger) count
{
   return( [[[self alloc] initWithObjects:objects
                                  forKeys:keys
                                    count:count] autorelease]);
}


#pragma mark - NSCopying

- (id) copy
{
   return( [self retain]);
}


#pragma mark - generic accessors


- (id) anyKey
{
   return( [[self keyEnumerator] nextObject]);
}


- (id) anyObject
{
   return( [[self objectEnumerator] nextObject]);
}



- (id) mulleForEachObjectAndKeyCallFunction:(BOOL (*)( id, id, void *)) f
                                   argument:(void *) userInfo
                                    preempt:(enum MullePreempt) preempt
{
   IMP   get;
   id    key;
   id    value;

   get = [self methodForSelector:@selector( objectForKey:)];
   switch( preempt)
   {
   case MullePreemptIfNotMatches :
         for( key in self)
         {
            value = MulleObjCCallIMP( get, self, @selector( objectForKey:), key);
            if( ! (*f)( value, key, userInfo))
               return( key);
         }
      break;

   case MullePreemptIfMatches :
         for( key in self)
         {
            value = MulleObjCCallIMP( get, self, @selector( objectForKey:), key);
            if( (*f)( value, key, userInfo))
               return( key);
         }
      break;

   default :
      for( key in self)
      {
         value = MulleObjCCallIMP( get, self, @selector( objectForKey:), key);
          (*f)( value, key, userInfo);
      }
   }
   return( nil);
}


// need @alias for this
- (id) :(id) key
{
   return( [self objectForKey:key]);
}



#pragma mark - hash and equality

//
// hard to pick anything off a NSDictionary, since the implementation
// is free to order them as they like
//
- (NSUInteger) hash
{
   return( mulle_hash_avalanche( [self count]));
}


- (BOOL) isEqualToDictionary:(NSDictionary *) other
{
   NSUInteger   count;
   id           key;
   id           value;
   id           other_value;

   if( other == self)
      return( YES);

   count = [self count];
   if( count != [other count])
      return( NO);

   if( ! count)
      return( YES);

   for( key in self)
   {
      other_value = [other objectForKey:key];
      if( ! other_value)
         return( NO);

      value = [self objectForKey:key];
      if( other_value == value)
         continue;

      if( [other_value hash] != [value hash])
         return( NO);
      if( ! [other_value isEqual:value])
         return( NO);
   }
   return( YES);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSDictionary])
      return( NO);
   return( [self isEqualToDictionary:other]);
}


- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) rover
                                   objects:(id *) buffer
                                     count:(NSUInteger) len;
{
   abort();  // subclass must do this
}

@end

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
#import "NSDictionary.h"

// other files in this library
#import "NSEnumerator.h"
#import "_MulleObjCDictionary.h"
#import "_MulleObjCConcreteDictionary.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies

@interface NSDictionary( NSCoder)

@end


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


+ (instancetype) dictionary
{
   return( [[[self alloc] init] autorelease]);
}


+ (instancetype) dictionaryWithDictionary:(NSDictionary *) other
{
   return( [[[self alloc] initWithDictionary:other] autorelease]);
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


#pragma mark -
#pragma mark class cluster inits

- (instancetype) init
{
   [self release];
   return( [_MulleObjCConcreteDictionary new]);
}


- (instancetype) initWithDictionary:(id) other
{
   [self release];
   return( [_MulleObjCConcreteDictionary newWithDictionary:other]);
}


- (instancetype) initWithObjects:(id *) obj
                         forKeys:(id *) key
                           count:(NSUInteger) count
{
   [self release];
   return( [_MulleObjCConcreteDictionary newWithObjects:obj
                                                forKeys:key
                                                  count:count]);
}


- (instancetype) initWithDictionary:(id) other
                          copyItems:(BOOL) copy
{
   [self release];
   return( [_MulleObjCConcreteDictionary newWithDictionary:other
                                                 copyItems:copy]);
}


- (instancetype) initWithObject:(id) obj
                 mulleVarargList:(mulle_vararg_list) args
{
   [self release];
   return( [_MulleObjCConcreteDictionary newWithObject:obj
                                             mulleVarargList:args]);
}


#pragma mark -
#pragma mark generic inits

- (instancetype) initWithObjectsAndKeys:(id) obj, ...
{
   mulle_vararg_list   args;
   id                  dictionary;

   mulle_vararg_start( args, obj);
   dictionary = [self initWithObject:obj
                     mulleVarargList:args];
   mulle_vararg_end( args);
   return( dictionary);
}


- (id) copy
{
   return( [self retain]);
}


#pragma mark -
#pragma mark accessors


- (id) anyKey
{
   return( [[self keyEnumerator] nextObject]);
}


- (id) anyObject
{
   return( [[self objectEnumerator] nextObject]);
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
   NSUInteger       count;
   NSEnumerator     *rover;
   id               key;
   id               value;
   id               other_value;

   if( other == self)
      return( YES);

   count = [self count];
   if( count != [other count])
      return( NO);

   if( ! count)
      return( YES);

   rover = [self keyEnumerator];
   while( key = [rover nextObject])
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

@end

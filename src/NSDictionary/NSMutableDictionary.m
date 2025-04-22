//
//  NSMutableDictionary.m
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
#pragma clang diagnostic ignored "-Wprotocol"

#import "NSMutableDictionary.h"

// other files in this library
#import "_NSMutableDictionaryPlaceholder.h"

// other libraries of MulleObjCContainerFoundation
#import "NSEnumerator.h"

// std-c and dependencies


@implementation NSObject( _NSMutableDictionary)

- (BOOL) __isNSMutableDictionary
{
   return( NO);
}

@end


@implementation NSMutableDictionary

- (BOOL) __isNSMutableDictionary
{
   return( YES);
}


+ (instancetype) dictionaryWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


- (id) mulleImmutableInstance
{
   return( [NSDictionary dictionaryWithDictionary:self]);
}


#pragma mark - class cluster


+ (Class) __classClusterClass
{
   return( [_NSMutableDictionaryPlaceholder class]);
}


#pragma mark - generic operations

- (void) addEntriesFromDictionary:(NSDictionary *) other
{
   id    key;
   id    value;
   SEL   selObjectForKey;
   IMP   impObjectForKey;
   SEL   selSetObjectForKey;
   IMP   impSetObjectForKey;

   selObjectForKey    = @selector( objectForKey:);
   impObjectForKey    = [other methodForSelector:selObjectForKey];
   selSetObjectForKey = @selector( setObject:forKey:);
   impSetObjectForKey = [self methodForSelector:selSetObjectForKey];

   for( key in other)
   {
      value = MulleObjCIMPCall( impObjectForKey, other, selObjectForKey, key);
      MulleObjCIMPCall2( impSetObjectForKey, self, selSetObjectForKey, value, key);
   }
}


- (void) setDictionary:(NSDictionary *) other
{
   [self removeAllObjects];
   [self addEntriesFromDictionary:other];
}


- (id) copy
{
   return( (id) [[NSDictionary alloc] initWithDictionary:self]);
}


- (id) immutableCopy
{
   return( (id) [[NSDictionary alloc] initWithDictionary:self]);
}


//
// basically the same as NSDictionary ( NSMutableDictionary)
// but we want to keep the class, or ?
//
- (instancetype) mulleDictionaryByRemovingObjectForKey:(id <NSObject, MulleObjCImmutableCopying>) key
{
   NSMutableDictionary   *copy;

   if( ! [self objectForKey:key])
      return( self);

   copy = [MulleObjCObjectGetClass( self) dictionaryWithDictionary:self];
   [copy removeObjectForKey:key];
   return( copy);
}

@end


@implementation NSDictionary ( NSMutableDictionary)

- (instancetype) mulleDictionaryByRemovingObjectForKey:(id <NSObject, MulleObjCImmutableCopying>) key
{
   NSMutableDictionary   *copy;

   if( ! [self objectForKey:key])
      return( self);

   copy = [NSMutableDictionary dictionaryWithDictionary:self];
   [copy removeObjectForKey:key];
   return( copy);
}

@end

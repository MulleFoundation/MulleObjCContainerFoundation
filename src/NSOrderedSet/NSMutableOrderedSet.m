//
//  NSMutableOrderedSet.m
//  MulleObjCContainerFoundation
//
//  Copyright (c) 2026 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
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

#import "NSMutableOrderedSet.h"

// other files in this library
#import "NSArray.h"
#import "_NSMutableOrderedSetPlaceholder.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies


@implementation NSObject( _NSMutableOrderedSet)

- (BOOL) __isNSMutableOrderedSet
{
   return( NO);
}

@end


@implementation NSMutableOrderedSet

- (BOOL) __isNSMutableOrderedSet
{
   return( YES);
}


+ (instancetype) orderedSetWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


- (id) mulleImmutableInstance
{
   return( [NSOrderedSet orderedSetWithOrderedSet:self]);
}


#pragma mark - class cluster


+ (Class) __classClusterClass
{
   return( [_NSMutableOrderedSetPlaceholder class]);
}


#pragma mark - generic operations


- (void) addObjectsFromArray:(NSArray *) array
{
   id   object;

   for( object in array)
      [self addObject:object];
}


- (id) copy
{
   return( [[NSOrderedSet alloc] initWithOrderedSet:self]);
}


@method_implementation -immutableCopy = -copy;


- (NSOrderedSet *) mulleOrderedSetByRemovingObject:(id) object
{
   NSMutableOrderedSet   *copy;

   if( ! [self containsObject:object])
      return( self);

   copy = [MulleObjCObjectGetClass( self) orderedSetWithOrderedSet:self];
   [copy removeObject:object];
   return( copy);
}

@end


@implementation NSOrderedSet( NSMutableOrderedSet)

- (NSOrderedSet *) mulleOrderedSetByRemovingObject:(id) object
{
   NSMutableOrderedSet   *copy;

   if( ! [self containsObject:object])
      return( self);

   copy = [NSMutableOrderedSet orderedSetWithOrderedSet:self];
   [copy removeObject:object];
   return( copy);
}

@end

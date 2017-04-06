//
//  NSMutableDictionary.m
//  MulleObjCFoundation
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
#import "NSMutableDictionary.h"

// other files in this library
#import "_MulleObjCConcreteMutableDictionary.h"
#import "MulleObjCContainerCallback.h"
#import "NSEnumerator.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


#define NSDictionaryCallback           ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueRetainCallback)
#define NSDictionaryCopyValueCallback  ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueCopyCallback)


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



+ (id) dictionaryWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


# pragma mark -
# pragma mark classcluster inits

- (instancetype) init
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary new]);
}


- (instancetype) initWithCapacity:(NSUInteger) capacity
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithCapacity:capacity]);
}


- (instancetype) initWithDictionary:(id) other
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithDictionary:other]);
}


- (instancetype) initWithObjects:(id *) obj
                         forKeys:(id *) key
                           count:(NSUInteger) count
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithObjects:obj
                                                       forKeys:key
                                                         count:count]);
}


- (instancetype) initWithDictionary:(id) other
                          copyItems:(BOOL) copy
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithDictionary:other
                                                        copyItems:copy]);
}


- (instancetype) initWithObject:(id) obj
                      arguments:(mulle_vararg_list) args
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithObject:obj
                                                   arguments:args]);
}

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSDictionary class]);
}


#pragma mark -
#pragma mark generic operations

- (void) addEntriesFromDictionary:(NSDictionary *) other
{
   NSEnumerator   *rover;
   id             key;
   id             value;

   rover = [other keyEnumerator];
   while( key = [rover nextObject])
   {
      value = [other objectForKey:key];
      [self setObject:value
      forKey:key];
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

@end


@implementation NSDictionary ( NSMutableDictionary)

- (id) mutableCopy
{
   return( [[NSMutableDictionary alloc] initWithDictionary:self]);
}

@end

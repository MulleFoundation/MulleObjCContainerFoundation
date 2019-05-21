//
//  NSMutableSet.m
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
#pragma clang diagnostic ignored "-Wprotocol"


#import "NSMutableSet.h"

// other files in this library
#import "_MulleObjCConcreteMutableSet.h"
#import "_NSMutableSetPlaceholder.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


@implementation NSMutableSet

+ (instancetype) setWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}

// as we are "breaking out" of the class cluster, use standard
// allocation

+ (Class) __placeholderClass
{
   return( [_NSMutableSetPlaceholder class]);
}


- (id) mulleImmutableInstance
{
   return( [NSSet setWithSet:self]);
}


+ (instancetype ) mulleInitWithCapacity:(NSUInteger) count
{
   return( (id) [[self alloc] initWithCapacity:count]);
}


#pragma mark -
#pragma mark operations

- (void) intersectSet:(NSSet *) other
{
   id             obj;
   NSEnumerator   *rover;
   IMP            nextObjectIMP;
   SEL            nextObjectSEL;
   IMP            removeObjectIMP;
   SEL            removeObjectSEL;
   IMP            memberObjectIMP;
   SEL            memberObjectSEL;

   rover         = [self objectEnumerator];

   nextObjectSEL = @selector( methodForSelector:);
   nextObjectIMP = [rover methodForSelector:nextObjectSEL];

   memberObjectSEL = @selector( member:);
   memberObjectIMP = [other methodForSelector:memberObjectSEL];

   removeObjectSEL = @selector( removeObject:);
   removeObjectIMP = [self methodForSelector:removeObjectSEL];

   while( obj = MulleObjCCallIMP0( nextObjectIMP, rover, nextObjectSEL))
      if( ! MulleObjCCallIMP( memberObjectIMP, other, memberObjectSEL, obj))
         MulleObjCCallIMP( removeObjectIMP, self, removeObjectSEL, obj);
}


- (void) minusSet:(NSSet *) other
{
   id             obj;
   NSEnumerator   *rover;
   IMP            nextObjectIMP;
   SEL            nextObjectSEL;
   IMP            removeObjectIMP;
   SEL            removeObjectSEL;

   rover = [other objectEnumerator];

   nextObjectSEL = @selector( methodForSelector:);
   nextObjectIMP = [rover methodForSelector:nextObjectSEL];

   removeObjectSEL = @selector( removeObject:);
   removeObjectIMP = [self methodForSelector:removeObjectSEL];

   while( obj = MulleObjCCallIMP0( nextObjectIMP, rover, nextObjectSEL))
      MulleObjCCallIMP( removeObjectIMP, self, removeObjectSEL, obj);
}


- (void) unionSet:(NSSet *) other
{
   id             obj;
   NSEnumerator   *rover;
   IMP            nextObjectIMP;
   SEL            nextObjectSEL;
   IMP            addObjectIMP;
   SEL            addObjectSEL;

   rover = [other objectEnumerator];

   nextObjectSEL = @selector( methodForSelector:);
   nextObjectIMP = [rover methodForSelector:nextObjectSEL];

   addObjectSEL = @selector( addObject:);
   addObjectIMP = [self methodForSelector:addObjectSEL];

   while( obj = MulleObjCCallIMP0( nextObjectIMP, rover, nextObjectSEL))
      MulleObjCCallIMP( addObjectIMP, self, addObjectSEL, obj);
}


- (void) setSet:(NSSet *) other
{
   [self removeAllObjects];
   [self unionSet:other];
}

- (id) copy
{
   return( [[NSSet alloc] initWithSet:self
                            copyItems:NO]);
}


@end


@implementation NSSet( NSMutableSet)

- (id) mutableCopy
{
   return( [[NSMutableSet alloc] initWithSet:self
                                   copyItems:NO]);
}

@end

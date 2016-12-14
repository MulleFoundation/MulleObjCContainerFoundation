//
//  NSMutableSet.m
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

#import "NSMutableSet.h"

// other files in this library
#import "_MulleObjCConcreteMutableSet.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSMutableSet

+ (instancetype) setWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


- (instancetype) initWithCapacity:(NSUInteger) numItems
{
   [self release];
   return( (id) [_MulleObjCConcreteMutableSet newWithCapacity:numItems]);
}


- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
                       copyItems:(BOOL) copyItems
{
   [self release];
   return( (id) [_MulleObjCConcreteMutableSet newWithObjects:objects
                                                       count:count
                                                   copyItems:copyItems]);
}


- (instancetype) initWithObject:(id) firstObject
                      arguments:(mulle_vararg_list) arguments
{
   [self release];
   return( (id) [_MulleObjCConcreteMutableSet newWithObject:firstObject
                                                  arguments:arguments]);
}

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSMutableSet class]);
}


+ (instancetype ) _allocWithCapacity:(NSUInteger) count
{
   return( (id) [_MulleObjCConcreteMutableSet newWithCapacity:count]);
}


- (id) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   
   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   
   return( (id) [_MulleObjCConcreteMutableSet _allocWithCapacity:count]);
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
   
   rover = [self objectEnumerator];

   nextObjectSEL = @selector( methodForSelector:);
   nextObjectIMP = [rover methodForSelector:nextObjectSEL];

   memberObjectSEL = @selector( member:);
   memberObjectIMP = [other methodForSelector:memberObjectSEL];

   removeObjectSEL = @selector( removeObject:);
   removeObjectIMP = [self methodForSelector:removeObjectSEL];
   
   while( obj = (*nextObjectIMP)( rover, nextObjectSEL, NULL))
      if( ! (*memberObjectIMP)( other, memberObjectSEL, obj))
         (*removeObjectIMP)( self, removeObjectSEL, obj);
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
   
   while( obj = (*nextObjectIMP)( rover, nextObjectSEL, NULL))
      (*removeObjectIMP)( rover, removeObjectSEL, obj);
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
   
   while( obj = (*nextObjectIMP)( rover, nextObjectSEL, NULL))
      (*addObjectIMP)( rover, addObjectSEL, obj);
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

//
//  NSMutableSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
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

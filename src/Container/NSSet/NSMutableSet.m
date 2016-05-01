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

@end

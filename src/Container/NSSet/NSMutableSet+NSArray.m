//
//  NSMutableSet+NSArray.m
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSMutableSet+NSArray.h"

// other files in this library
#import "NSArray.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSMutableSet (NSArray)

- (void) addObjectsFromArray:(NSArray *) array
{
   id   obj;
   IMP   addObjectIMP;
   SEL   addObjectSEL;
   
   addObjectSEL = @selector( addObject:);
   addObjectIMP = [self methodForSelector:addObjectSEL];
   
   for( obj in array)
      (*addObjectIMP)( self, addObjectSEL, obj);

}

@end

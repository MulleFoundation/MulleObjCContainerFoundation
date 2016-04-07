//
//  _MulleObjCEmptyArray.m
//  MulleObjCFoundation
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCEmptyArray.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation _MulleObjCEmptyArray

- (id) lastObject
{
   return( nil);
}


- (NSUInteger) count
{
   return( 0);
}


- (id) objectAtIndex:(NSUInteger) i
{
   MulleObjCThrowInvalidIndexException( i);
   return( nil);
}


- (NSArray *) sortedArrayUsingSelector:(SEL) comparator
{
   return( self);
}


- (NSArray *) sortedArrayUsingFunction:(NSInteger (*)(id, id, void *)) f
                               context:(void *) context
{
   return( self);
}

@end

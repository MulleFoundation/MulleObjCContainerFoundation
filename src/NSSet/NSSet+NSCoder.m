//
//  NSSet+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "NSSet+NSCoder.h"

#import "_NSSetPlaceholder.h"
#import "NSMutableSet.h"

#import "import-private.h"


@implementation NSSet (NSCoder)

- (Class) classForCoder
{
   return( [NSSet class]);
}


- (instancetype) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   return( [self mulleInitWithCapacity:count]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSUInteger     count;
   id             obj;

   count = (NSUInteger) [self count];
   [coder encodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   for( obj in self)
      [coder encodeObject:obj];
}


- (void) decodeWithCoder:(NSCoder *) coder
{
   abort();
}

@end



@implementation NSMutableSet (NSCoder)

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSMutableSet class]);
}

@end




//
//  NSArray+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSArray+NSCoder.h"

#import "_MulleObjCEmptyArray.h"
#import "_MulleObjCConcreteArray.h"
#import "_MulleObjCConcreteArray-Private.h"
#import "NSMutableArray.h"

#import "import-private.h"


@implementation NSArray( NSCoder)

#pragma mark - NSCoding

- (Class) classForCoder
{
   return( [NSArray class]);
}


- (instancetype) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           *objects;
   id           *sentinel;
   id           *p;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   if( ! count)
      return( [self init]);

   return( [self mulleInitWithCapacity:count]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           obj;

   count = (uint32_t) [self count];
   [coder encodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   for( obj in self)
      [coder encodeObject:obj];
}


- (void) decodeWithCoder:(NSCoder *) coder
{
   // done in _MulleObjCConcreteArray or other subclass
   abort();
}

@end


@implementation NSMutableArray( NSCoder)

- (Class) classForCoder
{
   return( [NSMutableArray class]);
}

@end

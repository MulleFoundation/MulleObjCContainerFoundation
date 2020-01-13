//
//  NSDictionary+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSDictionary+NSCoder.h"

#import "_NSDictionaryPlaceholder.h"
#import "NSMutableDictionary.h"

#import "_MulleObjCDictionary.h"

#import "import-private.h"


@implementation NSDictionary( NSCoder)

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSDictionary class]);
}


- (instancetype) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   self = [self mulleInitWithCapacity:count];
   return( self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSUInteger     count;
   id             key;
   id             value;

   count = (NSUInteger) [self count];
   [coder encodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   for( key in self)
   {
      value = [self objectForKey:key];
      [coder encodeObject:key];
      [coder encodeObject:value];
   }
}

- (void) decodeWithCoder:(NSCoder *) coder
{
   // subclasses must do it
   abort();
}

@end


@implementation NSMutableDictionary( NSCoder)

- (Class) classForCoder
{
   return( [NSMutableDictionary class]);
}

@end


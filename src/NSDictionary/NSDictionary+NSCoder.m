//
//  NSDictionary+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSDictionary+NSCoder.h"

#import "_NSDictionaryPlaceholder.h"
#import "_NSMutableDictionaryPlaceholder.h"

#import "_MulleObjCDictionary.h"
#import "_MulleObjCConcreteDictionary.h"
#import "_MulleObjCConcreteMutableDictionary.h"
#import "_MulleObjCDictionary-Private.h"
#import "_MulleObjCEmptyDictionary.h"

#import "import-private.h"


extern Class  _MulleObjCConcreteMutableDictionaryClass;


@implementation NSDictionary( NSCoder)

- (Class) classForCoder
{
   return( [NSDictionary class]);
}


- (instancetype) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   self = [self mulleInitForCoderWithCapacity:count];
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
      assert( value);
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


@implementation _NSDictionaryPlaceholder( NSCoder)

- (id) mulleInitForCoderWithCapacity:(NSUInteger) capacity
{
   if( ! capacity)
      return( [[_MulleObjCEmptyDictionaryClass sharedInstance] retain]);
   return( _MulleObjCDictionaryNewWithCapacity( _MulleObjCConcreteDictionaryClass,
                                                capacity));
}

@end


@implementation _NSMutableDictionaryPlaceholder( NSCoder)

- (instancetype) mulleInitForCoderWithCapacity:(NSUInteger) capacity
{
   assert( _MulleObjCConcreteMutableDictionaryClass);

   self = _MulleObjCDictionaryNewWithCapacity( _MulleObjCConcreteMutableDictionaryClass,
                                               capacity);
   return( self);
}

@end


@implementation _MulleObjCEmptyDictionary( NSCoder)

- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end


@implementation NSMutableDictionary( NSCoder)

- (Class) classForCoder
{
   return( [NSMutableDictionary class]);
}

@end


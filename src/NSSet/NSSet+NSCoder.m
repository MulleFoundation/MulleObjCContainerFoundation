//
//  NSSet+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "NSSet+NSCoder.h"

#import "_NSSetPlaceholder.h"
#import "_NSMutableSetPlaceholder.h"
#import "_MulleObjCSet.h"
#import "_MulleObjCSet-Private.h"
#import "_MulleObjCEmptySet.h"
#import "_MulleObjCConcreteSet.h"
#import "_MulleObjCConcreteMutableSet.h"

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
   return( [self mulleInitForCoderWithCapacity:count]);
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


//
// _MulleObjCSet
//
// - (void) decodeWithCoder:(NSCoder *) coder
//
// !!! declared in _MulleObjCSet
//

@implementation _NSSetPlaceholder( NSCoder)


- (instancetype) mulleInitForCoderWithCapacity:(NSUInteger) capacity
{
   _MulleObjCConcreteSet   *set;

   if( ! capacity)
      return( (id) [[_MulleObjCEmptySetClass sharedInstance] retain]);

   set = (id) _MulleObjCSetNewWithCapacity( _MulleObjCConcreteSetClass,
                                            capacity);
   return( (id) set);
}

@end


@implementation _MulleObjCEmptySet( NSCoder)

- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end



@implementation _NSMutableSetPlaceholder( NSCoder)

- (instancetype) mulleInitForCoderWithCapacity:(NSUInteger) count
{
   _MulleObjCConcreteMutableSet   *set;

   set = (id) _MulleObjCSetNewWithCapacity( _MulleObjCConcreteMutableSetClass,
                                            count);
   return( (id) set);
}

@end


@implementation NSMutableSet( NSCoder)

- (Class) classForCoder
{
   return( [NSMutableSet class]);
}

@end




//
//  NSArray+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSArray+NSCoder.h"

#import "_NSArrayPlaceholder.h"
#import "_MulleObjCEmptyArray.h"
#import "_MulleObjCConcreteArray.h"
#import "_MulleObjCConcreteArray-Private.h"
#import "NSMutableArray.h"

#import "import-private.h"


//
// try to keep all NSCoder related methods in here from various classes
// to make it slightly more palatable
//
@implementation NSArray( NSCoder)

#pragma mark - NSCoding

- (Class) classForCoder
{
   return( [NSArray class]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           obj;

   count = [self count];
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


- (instancetype) initWithCoder:(NSCoder *) coder
{
   // done in _NSArrayPlaceholder or other subclass
   abort();
}

@end


@implementation _NSArrayPlaceholder( NSCoder)

- (instancetype) initWithCoder:(NSCoder *) coder
{
   NSUInteger   capacity;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&capacity];
   if( ! capacity)
      return( (id) [[_MulleObjCEmptyArray sharedInstance] retain]);

   // hackish!! decodeWithCoder must follow
   return( (id) _MulleObjCConcreteArrayNewForCoderWithCapacity( _MulleObjCConcreteArrayClass,
                                                                capacity));
}

@end


@implementation _MulleObjCConcreteArray( NSCoder)

- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           *sentinel;
   id           *p;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   assert( count == _count);

   p        = _objects;
   assert( _objects == _MulleObjCConcreteArrayGetInlineObjects( self));
   sentinel = &p[ count];
   while( p < sentinel)
      [coder decodeValueOfObjCType:@encode( id)
                                at:p++];
}

@end


@implementation NSMutableArray( NSCoder)

- (Class) classForCoder
{
   return( [NSMutableArray class]);
}


- (instancetype) initWithCoder:(NSCoder *) coder
{
   NSUInteger   capacity;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&capacity];

   if( capacity)
   {
      self->_size    = capacity;
      self->_storage = MulleObjCInstanceAllocateNonZeroedMemory( self, sizeof( id) * capacity);
   }
   return( self);
}


- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           *sentinel;
   id           *p;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   assert( count == _size);

   p        = _storage;
   sentinel = &p[ count];
   while( p < sentinel)
      [coder decodeValueOfObjCType:@encode( id)
                                at:p++];
   _count = count;
   _mutationCount++;
}

@end

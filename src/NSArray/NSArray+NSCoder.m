//
//  NSArray+NSCoder.m
//  MulleObjCContainerFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
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
   MULLE_C_UNUSED( coder);
   // done in _MulleObjCConcreteArray or other subclass
   abort();
}


- (instancetype) initWithCoder:(NSCoder *) coder
{
   MULLE_C_UNUSED( coder);
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

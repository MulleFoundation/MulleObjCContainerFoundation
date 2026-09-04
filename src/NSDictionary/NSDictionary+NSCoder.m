//
//  NSDictionary+NSCoder.m
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
#import "NSDictionary+NSCoder.h"

#import "_NSDictionaryPlaceholder.h"
#import "_NSMutableDictionaryPlaceholder.h"

#import "_MulleObjCDictionary.h"
#import "_MulleObjCConcreteDictionary.h"
#import "_MulleObjCConcreteMutableDictionary.h"
#import "_MulleObjCDictionary-Private.h"
#import "_MulleObjCEmptyDictionary.h"

#import "import-private.h"

// yep extern
MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
Class  _MulleObjCConcreteMutableDictionaryClass;


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
   MULLE_C_UNUSED( coder);
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
   MULLE_C_UNUSED( coder);
}

@end

@implementation NSMutableDictionary( NSCoder)

- (Class) classForCoder
{
   return( [NSMutableDictionary class]);
}

@end


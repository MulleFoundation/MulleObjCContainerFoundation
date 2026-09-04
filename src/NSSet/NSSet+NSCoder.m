//
//  NSSet+NSCoder.m
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
   MULLE_C_UNUSED( coder);
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
   MULLE_C_UNUSED( coder);
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




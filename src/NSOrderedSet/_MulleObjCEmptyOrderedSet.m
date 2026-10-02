//
//  _MulleObjCEmptyOrderedSet.m
//  MulleObjCContainerFoundation
//
//  Copyright (c) 2026 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
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
#import "_MulleObjCEmptyOrderedSet.h"

// other files in this library

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies
#import "import-private.h"


#pragma clang diagnostic ignored "-Wprotocol"


@implementation _MulleObjCEmptyOrderedSet

MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL_VAR
Class  _MulleObjCEmptyOrderedSetClass;

+ (void) load
{
   _MulleObjCEmptyOrderedSetClass = [self class];
}


- (instancetype) __initSingleton
{
   return( self);
}


- (NSUInteger) count
{
   return( 0);
}


- (NSUInteger) indexOfObject:(id) object
{
   MULLE_C_UNUSED( object);
   return( NSNotFound);
}


- (id) objectAtIndex:(NSUInteger) index
{
   MULLE_C_UNUSED( index);
   MulleObjCThrowInvalidArgumentExceptionUTF8String( "index out of bounds");
   return( nil);
}


- (id) member:(id) object
{
   MULLE_C_UNUSED( object);
   return( nil);
}


- (NSEnumerator *) objectEnumerator
{
   return( nil);
}


- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) rover
                                   objects:(id *) buffer
                                     count:(NSUInteger) len
{
   MULLE_C_UNUSED( rover);
   MULLE_C_UNUSED( buffer);
   MULLE_C_UNUSED( len);
   return( 0);
}

@end

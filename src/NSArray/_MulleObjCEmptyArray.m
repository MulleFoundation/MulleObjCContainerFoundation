//
//  _MulleObjCEmptyArray.m
//  MulleObjCContainerFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "_MulleObjCEmptyArray.h"

// other files in this library

// std-c and dependencies
#import "import-private.h"


@implementation _MulleObjCEmptyArray

Class  _MulleObjCEmptyArrayClass;

+ (void) load
{
   _MulleObjCEmptyArrayClass = [self class];
}


- (id) __initSingleton
{
   return( self);
}


- (id) lastObject
{
   return( nil);
}

// defined in NSArray
// - (NSUInteger) count
// {
//    return( 0);
// }

- (void) getObjects:(id *) buf
              range:(NSRange) range
{
   MulleObjCValidateRangeAgainstLength( range, 0);
}


// need @alias for this
- (id) :(NSUInteger) i
{
   MulleObjCThrowInvalidIndexException( i);
   return( nil);
}


- (id) objectAtIndex:(NSUInteger) i
{
   MulleObjCThrowInvalidIndexException( i);
   return( nil);
}

- (void) decodeWithCoder:(NSCoder *) coder
{
}


- (NSArray *) sortedArrayUsingSelector:(SEL) comparator
{
   return( self);
}


- (NSArray *) sortedArrayUsingFunction:(NSComparisonResult (*)(id, id, void *)) f
                               context:(void *) context
{
   return( self);
}


- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) state
                                   objects:(id *) stackbuf
                                     count:(NSUInteger) len
{
   return( 0);
}

@end

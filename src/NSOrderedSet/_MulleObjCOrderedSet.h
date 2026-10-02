//
//  _MulleObjCOrderedSet.h
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
#import "NSOrderedSet.h"
#import "NSMutableOrderedSet.h"

#import <mulle-container/mulle-container.h>


//
// The ivars must be the first instance variable entry, if you're adopting
// the _MulleObjCOrderedSet protocol.
//
// The map is the main storage: object -> object, providing O(1) membership
// and uniqueness. The pointerarray holds the same objects in insertion order
// and is what gets enumerated.
//
typedef struct
{
   struct mulle__map          _table;
   struct mulle__pointerarray _order;
} _MulleObjCOrderedSetIvars;


// retains key and value (value is the object itself, so it's retained twice,
// which is balanced by the autorelease on removal)
#define NSOrderedSetCallback  ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerRetainKeyRetainValueCallback)


@mixin  _MulleObjCOrderedSet < NSFastEnumeration>

- (NSUInteger) count;
- (id) member:(id) object;
- (id) objectAtIndex:(NSUInteger) index;
- (id <NSEnumerator>) objectEnumerator;

@end

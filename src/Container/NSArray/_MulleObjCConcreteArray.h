//
//  _MulleObjCConcreteArray.h
//  MulleObjCFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "NSArray.h"


//
// you should not subclass _MulleObjCConcreteArray
// because there is extra data behind _count
//
@interface _MulleObjCConcreteArray : NSArray
{
   size_t   _count;
}

+ (instancetype) newWithObjects:(id *) objects
                count:(NSUInteger) count;

+ (instancetype) newWithRetainedObjects:(id *) objects
                        count:(NSUInteger) count;

+ (instancetype) newWithArray:(NSArray *) other
           copyItems:(BOOL) flag;

+ (instancetype) newWithObject:(id) firstObject
     mulleVarargList:(mulle_vararg_list) args;

+ (instancetype) newWithObject:(id) firstObject
          varargList:(va_list) args;

+ (instancetype) newWithArray:(NSArray *) other
          andObject:(id) obj              __attribute__(( ns_returns_retained));

+ (instancetype) newWithArray:(NSArray *) other
           andArray:(NSArray *) other2;

+ (instancetype) newWithArray:(NSArray *) other
              range:(NSRange) range;

+ (instancetype) newWithArray:(NSArray *) other
   sortedBySelector:(SEL) sel;

+ (instancetype) newWithArray:(NSArray *) other
       sortFunction:(NSInteger (*)( id, id, void *)) f
            context:(void *) context;

// used for NSCoder
+ (instancetype) _allocWithCapacity:(NSUInteger) count;

@end

//
//  _MulleObjCSet.h
//  MulleObjCFoundation
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

#import "NSSet.h"

#import "MulleObjCContainerCallback.h"

#import <mulle_container/mulle_container.h>


typedef struct
{
   struct _mulle_set        _table;
   struct mulle_allocator   *_allocator;
} _MulleObjCSetIvars;


#define NSSetCallback      MulleObjCContainerObjectKeyRetainCallback
#define NSSetCopyCallback  MulleObjCContainerObjectKeyCopyCallback



@protocol _MulleObjCSet

+ (instancetype) newWithCapacity:(NSUInteger) capacity;
+ (instancetype) newWithObject:(id) firstObject
                     arguments:(mulle_vararg_list) arguments;

+ (instancetype) newWithObjects:(id *) objects
                          count:(NSUInteger) count
                      copyItems:(BOOL) copyItems;

// NSCoder support
+ (instancetype) _allocWithCapacity:(NSUInteger) count;
- (void) _setObjects:(id *) objects
                keys:(id *) keys
               count:(NSUInteger) count;

+ (instancetype) _allocWithCapacity:(NSUInteger) count;
- (instancetype) _initWithObjects:(id *) objects
                            count:(NSUInteger) count;
@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"

@interface _MulleObjCSet < _MulleObjCSet>
@end

#pragma clang diagnostic pop


static inline _MulleObjCSetIvars  *getSetIvars( id self)
{
   return( (_MulleObjCSetIvars *)  self);
}


__attribute__((ns_returns_retained))
static inline _MulleObjCSet  *_MulleObjCNewSetWithCapacity( Class self, NSUInteger count)
{
   _MulleObjCSet        *set;
   _MulleObjCSetIvars   *ivars;
   
   set = NSAllocateObject( self, 0, NULL);
   
   ivars = getSetIvars( set);
   ivars->_allocator = MulleObjCObjectGetAllocator( set);
   _mulle_set_init( &ivars->_table,
                    (unsigned int)( count + (count >> 2)), // leave 25% spare room
                    NSSetCallback,
                    ivars->_allocator);

   return( set);
}

//
//  NSOrderedSet.h
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
#ifdef __has_include
# if __has_include( "MulleObjCContainer.h")
#  import "MulleObjCContainer.h"
# endif
#endif

#import "import.h"


@class NSArray;
@class NSEnumerator;
@class NSSet;
@class NSMutableOrderedSet;


//
// NSOrderedSet is an insertion-ordered set. It uses the NSSet access
// protocol (count and member:) plus the ordered additions below.
//
@interface NSOrderedSet : MulleObjCContainer < NSSet, MulleObjCClassCluster, MulleObjCImmutable, MulleObjCImmutableCopying >

+ (instancetype) orderedSet;
+ (instancetype) orderedSetWithObject:(id) object;
+ (instancetype) orderedSetWithObjects:(id) firstObject, ...;
+ (instancetype) orderedSetWithObjects:(id *) objects
                                 count:(NSUInteger) count;
+ (instancetype) orderedSetWithArray:(NSArray *) array;
+ (instancetype) orderedSetWithSet:(NSSet *) set;
+ (instancetype) orderedSetWithOrderedSet:(NSOrderedSet *) set;

- (instancetype) initWithObject:(id) object;
- (instancetype) initWithObjects:(id) firstObject, ...;
- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count;
- (instancetype) initWithObject:(id) object
                mulleVarargList:(mulle_vararg_list) args;
- (instancetype) initWithArray:(NSArray *) array;
- (instancetype) initWithSet:(NSSet *) set;
- (instancetype) initWithOrderedSet:(NSOrderedSet *) set;

- (id) firstObject;
- (id) lastObject;

- (BOOL) containsObject:(id) object;
- (NSUInteger) indexOfObject:(id) object;

- (NSArray *) array;
- (NSSet *) set;

- (BOOL) isEqualToOrderedSet:(NSOrderedSet *) other;

@end


@interface NSOrderedSet( SubclassesFuture) < NSFastEnumeration, MulleObjCFuture>

/* subclasses need to override those */
- (NSUInteger) count;
- (id) member:(id) object;
- (id) objectAtIndex:(NSUInteger) index;
- (void) getObjects:(id *) objects
              range:(NSRange) range;
- (NSEnumerator *) objectEnumerator;

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) rover
                                   objects:(id *) buffer
                                     count:(NSUInteger) len;
@end


@interface NSOrderedSet( _NSOrderedSetPlaceholder)

- (instancetype) mulleInitWithRetainedObjectStorage:(id *) objects
                                              count:(NSUInteger) count
                                               size:(NSUInteger) size;

- (instancetype) mulleInitWithRetainedObjects:(id *) objects
                                        count:(NSUInteger) count;

@end

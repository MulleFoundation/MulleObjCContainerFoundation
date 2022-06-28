//
//  NSArray.h
//  MulleObjCContainerFoundation
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
#import "import.h"

#import "MullePreempt.h"


@class NSEnumerator;


@interface NSArray : NSObject < NSArray, MulleObjCClassCluster, NSCopying>

+ (instancetype) array;
+ (instancetype) arrayWithArray:(NSArray *) other;
+ (instancetype) arrayWithObject:(id) obj;
+ (instancetype) arrayWithObjects:(id) firstObject, ...;
+ (instancetype) arrayWithObjects:(id *) objects
                            count:(NSUInteger) count;

- (instancetype) initWithArray:(NSArray *) other;
- (instancetype) initWithArray:(NSArray *) other
                     copyItems:(BOOL) flag;
- (instancetype) initWithObjects:(id) firstObject, ...;
- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count;
- (instancetype) initWithObject:(id) firstObject
                      arguments:(va_list) args;
- (NSArray *) arrayByAddingObject:(id) obj;
- (NSArray *) arrayByAddingObjectsFromArray:(NSArray *) other;

- (BOOL) containsObject:(id) obj;
- (id) firstObjectCommonWithArray:(NSArray *) other;
- (NSUInteger) indexOfObject:(id) obj;
- (NSUInteger) indexOfObject:(id) obj
                     inRange:(NSRange) range;
- (NSUInteger) indexOfObjectIdenticalTo:(id) obj;
- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
                                inRange:(NSRange) range;

- (BOOL) isEqual:(id) other;
- (BOOL) isEqualToArray:(NSArray *) other;
- (id) lastObject;
- (void) makeObjectsPerformSelector:(SEL) sel;
- (void) makeObjectsPerformSelector:(SEL) sel
                         withObject:(id) obj;

- (NSEnumerator *) objectEnumerator;
- (NSEnumerator *) reverseObjectEnumerator;

- (NSArray *) sortedArrayUsingFunction:(NSComparisonResult (*)(id, id, void *)) comparator
                               context:(void *) context;
- (NSArray *) sortedArrayUsingSelector:(SEL) comparator;
- (NSArray *) subarrayWithRange:(NSRange) range;

- (NSUInteger) hash;

- (BOOL) containsObject:(id) obj
                inRange:(NSRange) range;
- (void) getObjects:(id *) objects;


@end



@interface NSArray( MulleAdditions)

- (id) mulleFirstObject;
- (BOOL) mulleContainsObjectIdenticalTo:(id) obj;

// conveniences
+ (instancetype) mulleArrayWithArray:(NSArray *) other
                               range:(NSRange) range;

+ (instancetype) mulleArrayWithObjects:(id *) objects
                                 count:(NSUInteger) count;

+ (instancetype) mulleArrayWithRetainedObjects:(id *) objects
                                         count:(NSUInteger) count;

- (instancetype) mulleInitWithArray:(NSArray *) other
                              range:(NSRange) range;

- (instancetype) mulleInitWithArray:(NSArray *) other
                          andObject:(id) obj;

- (instancetype) mulleInitWithArray:(NSArray *) other
                           andArray:(NSArray *) other2;

- (instancetype) mulleInitWithObject:(id) firstObject
                           arguments:(va_list) argsM;

- (instancetype) initWithObject:(id) firstObject
                mulleVarargList:(mulle_vararg_list) args;

// mulle addition:
//
// userinfo will be passed to function. If the function preempts according to
// preempt (e.g. returns YES and preempt==MullePreemptIfMatches) then the
// object is returned. Otherwise nil is retuned.
//

- (id) mulleForEachObjectCallFunction:(BOOL (*)( id, void *)) f
                             argument:(void *) userInfo
                              preempt:(enum MullePreempt) preempt;
- (void) mulleMakeObjectsPerformSelector:(SEL) sel
                              withObject:(id) obj
                              withObject:(id) obj2;

@end


MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL
id   MulleForEachObjectCallFunction( id *objects,
                                     NSUInteger n,
                                     BOOL (*f)( id, void *),
                                     void *userInfo,
                                     enum MullePreempt preempt);


// minimum to implement
@interface NSArray( Subclasses) < NSFastEnumeration>

- (NSUInteger) count;
- (id) :(NSUInteger) index; // same as objectAtIndex, just a shortcut
- (id) objectAtIndex:(NSUInteger) index;
- (void) getObjects:(id *) objects
              range:(NSRange) range;

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) state
                                   objects:(id *) objects
                                     count:(NSUInteger) count;

@end


@interface NSArray( _NSArrayPlaceholder)

- (instancetype) mulleInitForCoderWithCapacity:(NSUInteger) count;
- (instancetype) mulleInitWithContainer:(id <NSFastEnumeration>) container;
// these two are the designated initializers basically
- (instancetype) mulleInitWithRetainedObjects:(id *) objects
                                       count:(NSUInteger) count;
- (instancetype) mulleInitWithRetainedObjectStorage:(id *) objects
                                              count:(NSUInteger) count
                                               size:(NSUInteger) size;
@end

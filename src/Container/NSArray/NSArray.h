//
//  NSArray.h
//  MulleObjCStandardFoundation
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
#import "MulleObjCFoundationBase.h"


@class NSEnumerator;


@interface NSArray : NSObject < MulleObjCClassCluster, NSCopying>

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

- (NSArray *) sortedArrayUsingFunction:(NSInteger (*)(id, id, void *)) comparator
                               context:(void *) context;
- (NSArray *) sortedArrayUsingSelector:(SEL) comparator;
- (NSArray *) subarrayWithRange:(NSRange) range;

- (NSUInteger) hash;

- (BOOL) containsObject:(id) obj
                inRange:(NSRange) range;
- (void) getObjects:(id *) objects;

// mulle addition:
//
// userinfo will be passed to function. If the function returns NO and
// isPreemptable is YES then the iteration will stop and the function will
// return NO. In all other cases YES is returned.
//
- (BOOL) mulleForEachObjectCallFunction:(BOOL (*)( id, void *)) f
                               argument:(void *) userInfo
                          isPreemptable:(BOOL) isPreemptable;
- (void) mulleMakeObjectsPerformSelector:(SEL) sel
                              withObject:(id) obj
                            withObject:(id) obj2;

@end


@interface NSArray( MulleAdditions)

- (instancetype) _initWithRetainedObjects:(id *) objects
                                    count:(NSUInteger) count;

+ (instancetype) arrayWithArray:(NSArray *) other
                          range:(NSRange) range;

- (instancetype) initWithArray:(NSArray *) other
                         range:(NSRange) range;

@end


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

//
//  NSMutableDictionary.h
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
#import "NSDictionary.h"

#import <mulle-container/mulle-container.h>


//
// NSMutableDictionary starts its own classcluster
//
@interface NSMutableDictionary : NSDictionary < NSMutableDictionary, MulleObjCClassCluster>

+ (instancetype) dictionaryWithCapacity:(NSUInteger) capacity;

@end


@interface NSMutableDictionary( _Subclasses)

- (instancetype) initWithCapacity:(NSUInteger) capacity;

- (void) addEntriesFromDictionary:(NSDictionary *) other;

- (void) removeAllObjects;
- (void) removeObjectForKey:(id)aKey;
- (void) setDictionary:(NSDictionary *) other;
- (void) setObject:(id) anObject
            forKey:(id <NSObject, MulleObjCImmutableCopying>) aKey;

// mulle addition:
- (void) mulleSetRetainedObject:(id) anObject
                         forKey:(id <NSObject, MulleObjCImmutableCopying>) aKey;
- (void) mulleSetRetainedObject:(id) anObject
                   forCopiedKey:(id <NSObject, MulleObjCImmutableCopying>) aKey;
@end


@interface NSDictionary ( NSMutableDictionary)

- (instancetype) mulleDictionaryByRemovingObjectForKey:(id <NSObject, MulleObjCImmutableCopying>) key;

@end


@interface NSMutableDictionary( _NSMutableDictionaryPlaceholder)
// not instancetype here
- (id) init;

- (id) mulleInitForCoderWithCapacity:(NSUInteger) count;

- (id) mulleInitWithRetainedObjectKeyStorage:(id *) objects
                                       count:(NSUInteger) count
                                        size:(NSUInteger) size;
- (id) mulleInitWithRetainedObjects:(id *) objects
                         copiedKeys:(id *) keys
                              count:(NSUInteger) count;
@end

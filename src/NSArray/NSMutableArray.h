//
//  NSMutableArray.h
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
#import "NSArray.h"


// NSMutableArray is not part of the NSArray classcluster
@interface NSMutableArray : NSArray < NSMutableArray, MulleObjCMutableContainerProtocols>
{
   id           *_storage;
   NSUInteger   _count;
   NSUInteger   _size;
   NSUInteger   _mutationCount;      // for ObjC 2.0
}

- (instancetype) initWithCapacity:(NSUInteger) capacity;

- (void) addObjectsFromArray:(NSArray *) otherArray;

- (void) addObject:(id) obj;
- (void) insertObject:(id) obj
              atIndex:(NSUInteger) index;
- (void) replaceObjectAtIndex:(NSUInteger) index
                   withObject:(id) obj;
- (void) removeLastObject;
- (void) removeObject:(id) obj;
- (void) removeObjectAtIndex:(NSUInteger) index;
- (void) removeObjectsInRange:(NSRange) range;
- (void) removeObjectIdenticalTo:(id) obj;
- (void) removeObjectIdenticalTo:(id) obj
                         inRange:(NSRange) range;

- (void) removeAllObjects;
- (void) exchangeObjectAtIndex:(NSUInteger) index1
             withObjectAtIndex:(NSUInteger) index2;
- (void) replaceObjectsInRange:(NSRange) range
                   withObjects:(id *) objects
                         count:(NSUInteger) count;

- (void) replaceObjectsInRange:(NSRange) aRange
          withObjectsFromArray:(NSArray *) other;

- (void) setArray:(NSArray *) other;

- (void) sortUsingSelector:(SEL)comparator;
- (void) sortUsingFunction:(NSComparisonResult (*)(id, id, void *)) compare
                   context:(void *) context;

+ (instancetype) arrayWithCapacity:(NSUInteger) capacity;

// mulle additions
- (void) mulleAddRetainedObject:(id) obj;
- (void) mulleReverseObjects;
- (void) mulleMoveObjectsInRange:(NSRange) range
                         toIndex:(NSUInteger) index;

// returns nil if none present
// otherwise will removeLastObject and return it
- (id) mulleRemoveLastObject;

@end


@interface NSArray( MulleMutableArrayAdditions)

- (NSArray *) mulleArrayByRemovingObject:(id) object;

@end

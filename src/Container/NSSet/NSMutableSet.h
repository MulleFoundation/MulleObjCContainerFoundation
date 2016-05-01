//
//  NSMutableSet.h
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSSet.h"


@interface NSMutableSet : NSSet < MulleObjCClassCluster>

+ (instancetype) setWithCapacity:(NSUInteger) numItems;
- (instancetype) initWithCapacity:(NSUInteger) numItems;

- (void) intersectSet:(NSSet *) other;
- (void) minusSet:(NSSet *) other;
- (void) unionSet:(NSSet *) other;
- (void) setSet:(NSSet *) other;

@end


@interface NSMutableSet( Subclasses)

- (void) addObject:(id) object;
- (void) removeObject:(id) object;
- (void) removeAllObjects;

@end


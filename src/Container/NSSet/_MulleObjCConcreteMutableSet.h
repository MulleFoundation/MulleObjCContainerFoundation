//
//  _MulleObjCConcreteMutableSet.h
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteSet.h"


@interface _MulleObjCConcreteMutableSet : _MulleObjCConcreteSet

+ (instancetype) newWithCapacity:(NSUInteger) count;

@end

//
//  _MulleObjCConcreteMutableSet.h
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSMutableSet.h"
#import "_MulleObjCSet.h"


@interface _MulleObjCConcreteMutableSet : NSMutableSet < _MulleObjCSet>
{
   _MulleObjCSetIvars   _ivars;
}

+ (instancetype) newWithCapacity:(NSUInteger) count;

@end

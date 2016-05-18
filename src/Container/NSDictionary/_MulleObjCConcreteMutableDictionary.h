//
//  _MulleObjCConcreteMutableDictionary.h
//  MulleObjCFoundation
//
//  Created by Nat! on 02.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSMutableDictionary.h"

#import "_MulleObjCDictionary.h"


@interface _MulleObjCConcreteMutableDictionary : NSMutableDictionary < _MulleObjCDictionary>
{
   _MulleObjCDictionaryIvars   _ivars;
}


+ (instancetype) newWithCapacity:(NSUInteger) capacity;
+ (instancetype) new;

@end

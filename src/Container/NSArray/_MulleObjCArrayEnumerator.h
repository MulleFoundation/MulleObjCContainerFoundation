//
//  MulleObjCArrayEnumerator.h
//  MulleObjCFoundation
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSEnumerator.h"


@class NSArray;


//
// keep this simplistic, since we support fast enumeration
//
@interface _MulleObjCArrayEnumerator : NSEnumerator
{
   NSArray   *_owner;
   NSRange   _range;
}

+ (id) enumeratorWithArray:(NSArray *) array;

@end


@interface MulleObjCArrayReverseEnumerator : _MulleObjCArrayEnumerator
{
}
@end

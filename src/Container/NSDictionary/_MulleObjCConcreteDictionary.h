//
//  _MulleObjCConcreteDictionary.h
//  MulleObjCFoundation
//
//  Created by Nat! on 05.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCDictionary.h"


@interface _MulleObjCConcreteDictionary : NSDictionary < _MulleObjCDictionary>
{
   _MulleObjCDictionaryIvars   _ivars;
}
@end


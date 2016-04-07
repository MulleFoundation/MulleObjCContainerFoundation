//
//  _MulleObjCConcreteDictionary.h
//  MulleObjCFoundation
//
//  Created by Nat! on 05.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSDictionary.h"

#import <mulle_container/mulle_container.h>


@interface _MulleObjCConcreteDictionary : NSDictionary
{
   struct _mulle_indexedkeyvaluebucket   _table;
   struct mulle_allocator                *_allocator;
}

@end


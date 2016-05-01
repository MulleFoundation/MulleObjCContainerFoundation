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
   struct _mulle_map        _table;
   struct mulle_allocator   *_allocator;
}

+ (instancetype) newWithDictionary:(id) other;
+ (instancetype) newWithObjects:(id *) obj
                        forKeys:(id *) key
                          count:(NSUInteger) count;
+ (instancetype) newWithDictionary:(id) other
                         copyItems:(BOOL) copy;
+ (instancetype) newWithObject:(id) object
                     arguments:(mulle_vararg_list) args;

@end


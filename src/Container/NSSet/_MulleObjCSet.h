//
//  _MulleObjCSet.h
//  MulleObjCFoundation
//
//  Created by Nat! on 17.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSSet.h"

#import "MulleObjCContainerCallback.h"

#import <mulle_container/mulle_container.h>


typedef struct
{
   struct _mulle_set        _table;
   struct mulle_allocator   *_allocator;
} _MulleObjCSetIvars;


#define NSSetCallback      MulleObjCContainerObjectKeyRetainCallback
#define NSSetCopyCallback  MulleObjCContainerObjectKeyCopyCallback


@protocol _MulleObjCSet

+ (instancetype) newWithCapacity:(NSUInteger) capacity;
+ (instancetype) newWithObject:(id) firstObject
                     arguments:(mulle_vararg_list) arguments;

+ (instancetype) newWithObjects:(id *) objects
                          count:(NSUInteger) count
                      copyItems:(BOOL) copyItems;

// NSCoder support
+ (instancetype) _allocWithCapacity:(NSUInteger) count;
- (void) _setObjects:(id *) objects
                keys:(id *) keys
               count:(NSUInteger) count;

+ (instancetype) _allocWithCapacity:(NSUInteger) count;
- (instancetype) _initWithObjects:(id *) objects
                            count:(NSUInteger) count;
@end



@interface _MulleObjCSet < _MulleObjCSet>
@end




static inline _MulleObjCSetIvars  *getSetIvars( id self)
{
   return( (_MulleObjCSetIvars *)  self);
}


__attribute__((ns_returns_retained))
static inline _MulleObjCSet  *_MulleObjCNewSetWithCapacity( Class self, NSUInteger count)
{
   _MulleObjCSet        *set;
   _MulleObjCSetIvars   *ivars;
   
   set = NSAllocateObject( self, 0, NULL);
   
   ivars = getSetIvars( set);
   ivars->_allocator = MulleObjCObjectGetAllocator( set);
   _mulle_set_init( &ivars->_table,
                    (unsigned int)( count + (count >> 2)), // leave 25% spare room
                    NSSetCallback,
                    ivars->_allocator);

   return( set);
}


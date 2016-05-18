//
//  _MulleObjCDictionary.h
//  MulleObjCFoundation
//
//  Created by Nat! on 02.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import "NSDictionary.h"

#import "MulleObjCContainerCallback.h"

#import <mulle_container/mulle_container.h>


typedef struct
{
   struct _mulle_map        _table;
   struct mulle_allocator   *_allocator;
} _MulleObjCDictionaryIvars;


#define NSDictionaryCallback           ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueRetainCallback)
#define NSDictionaryCopyValueCallback  ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueCopyCallback)


@protocol _MulleObjCDictionary

+ (instancetype) new;
+ (instancetype) newWithDictionary:(id) other;
+ (instancetype) newWithObjects:(id *) obj
                        forKeys:(id *) key
                          count:(NSUInteger) count;
+ (instancetype) newWithDictionary:(id) other
                         copyItems:(BOOL) copy;
+ (instancetype) newWithObject:(id) object
                     arguments:(mulle_vararg_list) args;

// NSCoder support
+ (instancetype) _allocWithCapacity:(NSUInteger) count;
- (void) _setObjects:(id *) objects
                keys:(id *) keys
               count:(NSUInteger) count;
@end



@interface _MulleObjCDictionary < _MulleObjCDictionary>
@end


static inline _MulleObjCDictionaryIvars  *getDictionaryIvars( id self)
{
   return( (_MulleObjCDictionaryIvars *)  self);
}


__attribute__((ns_returns_retained))
static inline _MulleObjCDictionary  *_MulleObjCNewDictionaryWithCapacity( Class self, NSUInteger count)
{
   _MulleObjCDictionary        *dictionary;
   _MulleObjCDictionaryIvars   *ivars;
   
   dictionary = NSAllocateObject( self, 0, NULL);
   
   ivars = getDictionaryIvars( dictionary);
   ivars->_allocator = MulleObjCObjectGetAllocator( dictionary);
   _mulle_map_init( &ivars->_table,
                    count + (count >> 2), // leave 25% spare room
                    NSDictionaryCallback,
                    ivars->_allocator);

   return( dictionary);
}

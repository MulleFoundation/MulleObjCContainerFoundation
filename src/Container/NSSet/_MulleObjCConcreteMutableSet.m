//
//  _MulleObjCConcreteMutableSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteMutableSet.h"

// other files in this library
#import "NSEnumerator.h"
#import "MulleObjCContainerCallback.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation _MulleObjCConcreteMutableSet

+ (instancetype) newWithCapacity:(NSUInteger) capacity
{
   struct mulle_allocator         *allocator;
   _MulleObjCConcreteMutableSet   *obj;
   
   obj       = NSAllocateObject( self, 0, NULL);
   allocator = MulleObjCObjectGetAllocator( obj);

   mulle_set_init( &obj->_set,
                   (unsigned int) capacity,
                   MulleObjCContainerObjectKeyRetainCallback,
                   allocator);

   return( obj);
}


- (void) addObject:(id) obj
{
   mulle_set_set( &self->_set, obj);
}


- (void) removeObject:(id) obj
{
   mulle_set_remove( &self->_set, obj);
}


- (void) removeAllObjects
{
   mulle_set_reset( &self->_set);
}

@end

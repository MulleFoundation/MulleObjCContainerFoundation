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


+ (instancetype) newWithCapacity:(NSUInteger) count
{
   id   obj;
   
   obj = _MulleObjCNewSetWithCapacity( self, count);
   return( obj);
}


- (void) addObject:(id) obj
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   _mulle_set_set( &ivars->_table, obj, NSSetCallback, ivars->_allocator);
}


- (void) removeObject:(id) obj
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   _mulle_set_remove( &ivars->_table, obj, NSSetCallback, ivars->_allocator);
}


- (void) removeAllObjects
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   _mulle_set_reset( &ivars->_table, NSSetCallback, ivars->_allocator);
}

@end

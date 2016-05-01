//
//  NSConcreteSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 15.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteSet.h"

// other files in this library
#import "NSEnumerator.h"
#import "MulleObjCContainerCallback.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies
#include <mulle_container/mulle_container.h>



@interface _MulleObjCConcreteSetEnumerator : NSEnumerator
{
   NSSet                       *_owner;
   struct mulle_setenumerator  _rover;
}

- (instancetype) initWithConcreteSet:(_MulleObjCConcreteSet *) set
                           mulle_set:(struct mulle_set *) _set;

@end


@implementation _MulleObjCConcreteSetEnumerator

- (instancetype) initWithConcreteSet:(_MulleObjCConcreteSet *) set
                           mulle_set:(struct mulle_set *) _set
{
   _owner = [set retain];
   _rover = mulle_set_enumerate( _set);
   return( self);
}

- (void) dealloc

{
   mulle_setenumerator_done( &_rover);

   [_owner release];

   [super dealloc];
}


- (id) nextObject
{
   return( mulle_setenumerator_next( &_rover));
}

@end


@implementation _MulleObjCConcreteSet


+ (instancetype) newWithObject:(id) firstObject
                     arguments:(mulle_vararg_list) arguments
{
   struct mulle_allocator   *allocator;
   _MulleObjCConcreteSet    *obj;
   NSUInteger               count;
   id                       nextObject;

   assert( firstObject);
   
   obj       = NSAllocateObject( self, 0, NULL);
   allocator = MulleObjCObjectGetAllocator( obj);

   count = mulle_vararg_count( arguments, firstObject);
   mulle_set_init( &obj->_set,
                   (unsigned int) count,
                   MulleObjCContainerObjectKeyRetainCallback,
                   allocator);

   mulle_set_set( &obj->_set, firstObject);
   while( nextObject = mulle_vararg_next( arguments))
      mulle_set_set( &obj->_set, nextObject);

   return( obj);
}


+ (instancetype) newWithObjects:(id *) objects
                          count:(NSUInteger) count
                      copyItems:(BOOL) copyItems
{
   struct mulle_allocator   *allocator;
   _MulleObjCConcreteSet    *obj;
   
   obj       = NSAllocateObject( self, 0, NULL);
   allocator = MulleObjCObjectGetAllocator( obj);

   mulle_set_init( &obj->_set,
                   (unsigned int) count,
                   copyItems ? MulleObjCContainerObjectKeyCopyCallback
                             : MulleObjCContainerObjectKeyRetainCallback,
                   allocator);

   while( count)
   {
      mulle_set_set( &obj->_set, *objects++);
      --count;
   }
   return( obj);
}


- (void) dealloc
{
   mulle_set_done( &_set);
   [super dealloc];
}


- (NSEnumerator *) objectEnumerator
{
   return( [[_MulleObjCConcreteSetEnumerator instantiate] initWithConcreteSet:self
                                                             mulle_set:&_set]);
}


- (BOOL) containsObject:(id) obj
{
   return( mulle_set_get( &self->_set, obj) != NULL);
}


- (id) member:(id) obj
{
   return( mulle_set_get( &self->_set, obj));
}


- (NSUInteger) count
{
   return( mulle_set_get_count( &self->_set));
}

@end


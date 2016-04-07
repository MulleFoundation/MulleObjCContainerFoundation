//
//  NSConcreteSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 15.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteSet.h"

#import "NSEnumerator.h"
#import "_MulleObjCContainerCallback.h"

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

- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
                       copyItems:(BOOL) copyItems
{
   struct mulle_allocator   *allocator;
   
   allocator = MulleObjCAllocator();
   mulle_set_init( &_set,
                   count,
                   copyItems ? MulleObjCContainerObjectKeyCopyCallback : MulleObjCContainerObjectKeyRetainCallback,
                   allocator);

   while( count)
   {
      mulle_set_insert( &_set, *objects++);
      --count;
   }
   return( self);
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


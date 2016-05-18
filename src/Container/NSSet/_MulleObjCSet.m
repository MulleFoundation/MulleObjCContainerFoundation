//
//  _MulleObjCSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 17.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCSet.h"

// other files in this library
#import "NSEnumerator.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies




@interface _MulleObjCSetEnumerator : NSEnumerator
{
   _MulleObjCSet< NSObject>     *_owner;
   struct _mulle_setenumerator  _rover;
}

- (instancetype) initWithSet:(_MulleObjCSet<NSObject> *) set
                  _mulle_set:(struct _mulle_set *) _set;

@end


@implementation _MulleObjCSetEnumerator

- (instancetype) initWithSet:(_MulleObjCSet<NSObject> *) set
                  _mulle_set:(struct _mulle_set *) _set
{
   _owner = [set retain];
   _rover = _mulle_set_enumerate( _set, NSSetCallback);
   return( self);
}

- (void) dealloc

{
   _mulle_setenumerator_done( &_rover);

   [_owner release];
   [super dealloc];
}


- (id) nextObject
{
   return( _mulle_setenumerator_next( &_rover));
}

@end


@implementation _MulleObjCSet

static void   _addEntriesFromCollection( id other,
                                         struct _mulle_set *table,
                                         BOOL copyItems,
                                         struct mulle_allocator *allocator)
{
   NSEnumerator                         *rover;
   id                                   obj;
   id                                   (*impNext)( id, SEL, id);
   SEL                                  selNext;
   struct mulle_container_keycallback   *callback;

   callback = copyItems ? NSSetCopyCallback
                        : NSSetCallback;
      
   rover   = [other objectEnumerator];
   selNext = @selector( nextObject:);
   impNext = (void *) [rover methodForSelector:selNext];
   
   while( obj = (*impNext)( rover, selNext, NULL))
      _mulle_set_set( table, obj, callback, allocator);
}


static id    initWithObjects( _MulleObjCSet *self, id *objects, NSUInteger count, BOOL copyItems)
{
   _MulleObjCSetIvars   *ivars;
   
   ivars = getSetIvars( self);
   _mulle_set_init( &ivars->_table,
                  (unsigned int) count,
                  copyItems ? MulleObjCContainerObjectKeyCopyCallback
                  : MulleObjCContainerObjectKeyRetainCallback,
                  ivars->_allocator);
   
   while( count)
   {
      _mulle_set_set( &ivars->_table, *objects++, NSSetCallback, ivars->_allocator);
      --count;
   }
   return( self);
}


+ (instancetype) newWithObject:(id) firstObject
                     arguments:(mulle_vararg_list) arguments
{
   NSUInteger           count;
   _MulleObjCSet        *obj;
   _MulleObjCSetIvars   *ivars;
   id                   nextObject;
   
   assert( firstObject);
   
   count = mulle_vararg_count( arguments, firstObject);
   obj   = _MulleObjCNewSetWithCapacity( self, count);
   ivars = getSetIvars( obj);
   
   _mulle_set_set( &ivars->_table, firstObject, NSSetCallback, ivars->_allocator);
   while( nextObject = mulle_vararg_next( arguments))
      _mulle_set_set( &ivars->_table, nextObject, NSSetCallback, ivars->_allocator);

   return( obj);
}


+ (id) _allocWithCapacity:(NSUInteger) count
{
   id   obj;
   
   obj = _MulleObjCNewSetWithCapacity( self, count);
   return( obj);
}


+ (instancetype) newWithObjects:(id *) objects
                          count:(NSUInteger) count
                      copyItems:(BOOL) copyItems
{
   id   obj;
   
   obj   = _MulleObjCNewSetWithCapacity( self, count);
   initWithObjects( obj, objects, count, copyItems);
   return( obj);
}


- (instancetype) _initWithObjects:(id *) objects
                            count:(NSUInteger) count
{
   return( initWithObjects( self, objects, count, NO));
}


- (void) dealloc
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   _mulle_set_done( &ivars->_table, NSSetCallback, ivars->_allocator);

   NSDeallocateObject( self);
}


- (NSEnumerator *) objectEnumerator
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   return( [[_MulleObjCSetEnumerator instantiate] initWithSet:(id) self
                                                    _mulle_set:&ivars->_table]);
}


- (BOOL) containsObject:(id) obj
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   return( _mulle_set_get( &ivars->_table, obj, NSSetCallback) != NULL);
}


- (id) member:(id) obj
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   return( _mulle_set_get( &ivars->_table, obj, NSSetCallback));
}


- (NSUInteger) count
{
   _MulleObjCSetIvars *ivars;

   ivars = getSetIvars( self);
   return( _mulle_set_get_count( &ivars->_table));
}

@end


/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  MulleObjCConcreteArray.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCConcreteArray.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies
#include <stdlib.h>



@implementation _MulleObjCConcreteArray

static inline id   *get_objects( _MulleObjCConcreteArray *self)
{
   return( (id *) (&self->_count + 1));
}


__attribute__((ns_returns_retained))
static inline _MulleObjCConcreteArray  *_MulleObjCNewConcreteArrayWithCapacity( Class self, NSUInteger count)
{
   _MulleObjCConcreteArray  *array;

   array = NSAllocateObject( self, count * sizeof( id), NULL);
   array->_count = count;
   return( array);
}


static id   initWithRetainedObjects( _MulleObjCConcreteArray *self,
                                     id *objects,
                                    NSUInteger count)
{
   id   *buffer;
   id   *sentinel;
   id   obj;

   buffer   = get_objects( self);
   sentinel = &buffer[ count];

   while( buffer < sentinel)
   {
      obj = *objects++;
      if( ! obj)
         MulleObjCThrowInvalidArgumentException( @"passed in a nil object at index %ld", buffer - get_objects( self));
      *buffer++ = obj;
   }
   return( self);

}

+ (id) newWithObjects:(id *) objects
                count:(NSUInteger) count
{
   _MulleObjCConcreteArray   *array;

   array = _MulleObjCNewConcreteArrayWithCapacity( self, count);

   MulleObjCMakeObjectsPerformRetain( objects, count);
   return( initWithRetainedObjects( array, objects, count));
}


+ (id) newWithRetainedObjects:(id *) objects
                        count:(NSUInteger) count
{
   _MulleObjCConcreteArray   *array;

   array    = _MulleObjCNewConcreteArrayWithCapacity( self, count);
   return( initWithRetainedObjects( array, objects, count));
}


+ (id) newWithArray:(NSArray *) other
              range:(NSRange) range
          copyItems:(BOOL) flag
{
   _MulleObjCConcreteArray   *array;
   id                        *objects;

   array  = _MulleObjCNewConcreteArrayWithCapacity( self, range.length);
   objects = get_objects( array);
   [other getObjects:objects
               range:range];
   if( flag)
      MulleObjCMakeObjectsPerformSelector( objects, range.length, @selector( copy), NULL);
   else
      MulleObjCMakeObjectsPerformRetain( objects, range.length);
   return( array);
}


+ (id) newWithArray:(NSArray *) other
          copyItems:(BOOL) flag
{
   _MulleObjCConcreteArray   *array;
   id                        *objects;
   NSUInteger                count;

   count   = [other count];
   array   = _MulleObjCNewConcreteArrayWithCapacity( self, count);
   objects = get_objects( array);
   [other getObjects:objects];

   if( flag)
      MulleObjCMakeObjectsPerformSelector( objects, count, @selector( copy), NULL);
   else
      MulleObjCMakeObjectsPerformRetain( objects, count);
   return( array);
}


+ (id) newWithObject:(id) firstObject
           arguments:(mulle_vararg_list) args
{
   _MulleObjCConcreteArray   *array;
   id                        value;
   NSUInteger                count;
   id                        *objects;
   id                        *p;

   count = mulle_vararg_count( args, firstObject);

   array = _MulleObjCNewConcreteArrayWithCapacity( self, count);

   objects = p = get_objects( array);
   value   = firstObject;
   while( value)
   {
      *p++  = value;
      value = mulle_vararg_next( args);
   }

   MulleObjCMakeObjectsPerformRetain( objects, count);

   return( array);
}


+ (id) newWithArray:(NSArray *) other
          andObject:(id) obj
{
   _MulleObjCConcreteArray   *array;
   id                        *objects;
   NSUInteger                count;

   assert( obj);

   count = [other count];
   array  = _MulleObjCNewConcreteArrayWithCapacity( self, count + 1);

   objects = get_objects( array);
   [other getObjects:objects];
   objects[ count] = obj;

   MulleObjCMakeObjectsPerformRetain( objects, count + 1);

   return( array);
}


+ (id) newWithArray:(NSArray *) other
           andArray:(NSArray *) other2
{
   _MulleObjCConcreteArray    *array;
   id                         *objects;
   NSUInteger                 count;
   NSUInteger                 count2;

   count   = [other count];
   count2  = [other2 count];

   array  = _MulleObjCNewConcreteArrayWithCapacity( self, count + count2);

   objects = get_objects( array);
   [other getObjects:objects];
   [other2 getObjects:&objects[ count]];

   MulleObjCMakeObjectsPerformRetain( objects, count + count2);

   return( array);
}


+ (id) newWithArray:(NSArray *) other
              range:(NSRange) range
{
   _MulleObjCConcreteArray   *array;
   id                        *objects;

   array  = _MulleObjCNewConcreteArrayWithCapacity( self, range.length);

   objects = get_objects( array);
   [other getObjects:objects
               range:range];

   MulleObjCMakeObjectsPerformRetain( objects,  range.length);

   return( array);
}


typedef struct
{
   NSInteger   (*f)( id, id, void *);
   void        *ctxt;
} bouncy;


static int   bouncyBounce( bouncy *ctxt, id *a, id *b)
{
   return( (int) (ctxt->f)( *a, *b, ctxt->ctxt));
}


+ (id) newWithArray:(NSArray *) other
       sortFunction:(NSInteger (*)( id, id, void *)) f
            context:(void *) context
{
   _MulleObjCConcreteArray   *array;
   bouncy                    bounce;

   bounce.f    = f;
   bounce.ctxt = context;

   array  = [self newWithArray:other
                     copyItems:NO];
   qsort_r( get_objects( array), array->_count, sizeof( id), (void *) &bounce, (void *) &bouncyBounce);
   return( array);
}


static int   bouncyBounceSel( void *ctxt, id *a, id *b)
{
   return( (int) mulle_objc_object_call( *a, (mulle_objc_methodid_t) ctxt, *b));
}


+ (id) newWithArray:(NSArray *) other
    sortedBySelector:(SEL) sel
{
   _MulleObjCConcreteArray    *array;
   NSUInteger                 count;

   count = [other count];
   array = [self newWithArray:other
                        range:NSMakeRange( 0, count)
                    copyItems:NO];
   qsort_r( get_objects( array), count, sizeof( id), (void *) (intptr_t) sel, (void *) bouncyBounceSel);

   return( array);
}


- (void) dealloc
{
   MulleObjCMakeObjectsPerformRelease( get_objects( self), _count);
   NSDeallocateObject( self);
}


#pragma mark -
#pragma mark NSCoder

+ (id) _allocWithCapacity:(NSUInteger) count
{
   return( _MulleObjCNewConcreteArrayWithCapacity( self, count));
}


- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           *p;
   id           *sentinel;
   id           *objects;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   assert( self->_count && count);

   objects = get_objects( self);
   p        = objects;
   sentinel = &p[ count];

   while( p < sentinel)
   {
      [coder decodeValueOfObjCType:@encode( id)
                                at:p];
      ++p;
   }
}


#pragma mark -
#pragma mark operations

static NSUInteger   findObject( _MulleObjCConcreteArray *self,
                                id obj,
                                BOOL (*f)( id, SEL, id), SEL sel)
{
   id           *buffer;
   id           *sentinel;
   id           *p;
   NSUInteger   i;

   buffer   = get_objects( self);
   sentinel = &buffer[ self->_count];

   i = 0;
   if( f)
   {
      for( p = buffer; p < sentinel; p++, i++)
         if( (*f)( obj, sel, *p))
            return( i);
   }
   else
   {
      for( p = buffer; p < sentinel; p++, i++)
         if( obj == *p)
            return( i);
   }

   return( NSNotFound);
}


static NSUInteger   findObjectWithRange( _MulleObjCConcreteArray *self,
                                         NSRange range,
                                         id obj,
                                         BOOL (*f)( id, SEL, id), SEL sel)
{
   NSUInteger   sentinelLength;
   id           *buffer;
   id           *sentinel;
   id           *p;
   NSUInteger   i;

   sentinelLength = range.location + range.length;
   if( sentinelLength > self->_count || range.length > self->_count)
      MulleObjCThrowInvalidRangeException( range);

   buffer   = get_objects( self);
   sentinel = &buffer[ sentinelLength];

   i = range.location;
   if( f)
   {
      for( p = &buffer[ range.location]; p < sentinel; p++, i++)
         if( (*f)( obj, sel, *p))
            return( i);
   }
   else
   {
      for( p = &buffer[ range.location]; p < sentinel; p++, i++)
         if( obj == *p)
            return( i);
   }

   return( NSNotFound);
}


- (NSUInteger) indexOfObject:(id) obj
{
   SEL    selEqual;
   BOOL   (*impEqual)( id, SEL, id);

   selEqual = @selector( isEqual:);
   impEqual = (void *) [obj methodForSelector:selEqual];
   return( findObject( self, obj, impEqual, selEqual));
}


- (NSUInteger) indexOfObject:(id) obj
                     inRange:(NSRange) range
{
   SEL     selEqual;
   BOOL    (*impEqual)( id, SEL, id);

   selEqual = @selector( isEqual:);
   impEqual = (void *) [obj methodForSelector:selEqual];
   return( findObjectWithRange( self, range, obj, impEqual, selEqual));
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
{
   return( findObject( self, obj, NULL, (SEL) 0));
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
                                inRange:(NSRange) range
{
   return( findObjectWithRange( self, range, obj, NULL, (SEL) 0));
}


- (id) lastObject
{
   if( ! _count)
      return( nil);

   return( get_objects( self)[_count - 1]);
}


- (void) makeObjectsPerformSelector:(SEL) sel
{
   MulleObjCMakeObjectsPerformSelector( get_objects( self), _count, sel, nil);
}


- (void) makeObjectsPerformSelector:(SEL) sel
                         withObject:(id) obj
{
   MulleObjCMakeObjectsPerformSelector( get_objects( self), _count, sel, obj);
}


- (id) objectAtIndex:(NSUInteger) i
{
   if( i >= _count)
      MulleObjCThrowInvalidIndexException( i);

   return( get_objects( self)[ i]);
}


- (NSUInteger) count
{
   return( _count);
}


- (void) getObjects:(id *) buf
              range:(NSRange) range
{
   if( range.location + range.length > _count || range.length > _count)
      MulleObjCThrowInvalidRangeException( range);

   memcpy( buf, &get_objects( self)[ range.location], sizeof( id) * range.length);
}


- (void) getObjects:(id *) buf
{
   memcpy( buf, get_objects( self), sizeof( id) * _count);
}



//
// https://www.mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html
//
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) state
                                   objects:(id *) stackbuf
                                     count:(NSUInteger) len
{
   if( ! state->state)
   {
      state->mutationsPtr = (unsigned long *)self;
      state->itemsPtr     = get_objects( self);
      state->state        = 1;
      return( self->_count);
   }
   return( 0);
}


#if DEBUG

- (id) retain
{
   return( [super retain]);
}


- (id) autorelease
{
   return( [super autorelease]);
}


- (void) release
{
   [super release];
}

#endif

@end

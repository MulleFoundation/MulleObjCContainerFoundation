/*
 *  NSTinyFoundation - the mulle-objc class library
 *
 *  NSMutableArray.m is a part of NSTinyFoundation
 *
 *  Copyright (C) 2011 Nat!, NS kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSMutableArray.h"

// other files in this library
#include "mulle_qsort_pointers.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies



@implementation NSMutableArray

#pragma mark -
#pragma mark construction conveniences

+ (id) arrayWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}



static void   add_object( NSMutableArray *self, id other);


- (void) dealloc
{
   MulleObjCMakeObjectsPerformRelease( _storage, _count);
   MulleObjCObjectDeallocateMemory( self, _storage);

   [super dealloc];
}


#pragma mark -
#pragma mark init

static id   initWithArrayAndRange( NSMutableArray *self, NSArray *other, NSRange range)
{
   assert( [other count] >= range.location + range.length);
   
   self->_count = range.length;
   self->_size  = self->_count;
   if( self->_size < 8)
      self->_size = 8;

   self->_storage = MulleObjCObjectReallocateNonZeroedMemory( self, self->_storage, sizeof( id) * self->_size);
   [other getObjects:self->_storage
               range:range];

   MulleObjCMakeObjectsPerformRetain( self->_storage, range.length);

   self->_mutationCount++;
   return( self);
}


static id  initWithRetainedObjects( NSMutableArray *self,
                                    id *objects,
                                    NSUInteger n)
{
#ifndef NDEBUG
   {
      unsigned int   i;
      
      for( i = 0; i < n; i++)
         assert( objects[ i]);
   }
#endif
   self->_size  = n;
   self->_count = n;
   if( n < 8)
      self->_size = 8;
   self->_storage = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * self->_size);
	 
   memcpy( self->_storage, objects, n * sizeof( id));
   return( self);
}


static id  initWithObjects( NSMutableArray *self,
                            id *objects,
                            NSUInteger n)
{
   self = initWithRetainedObjects( self, objects, n);
   MulleObjCMakeObjectsPerformRetain( objects, n);
   return( self);
}


- (id) initWithArray:(NSArray *) other
{
   NSRange  range;
   
   range = NSMakeRange( 0, [other count]);
   initWithArrayAndRange( self, other, range);
   return( self);
}


- (id) initWithArray:(NSArray *) other
               range:(NSRange) range
{
   return( initWithArrayAndRange( self, other, range));
}


- (id) initWithObjects:(id *) objects
                 count:(NSUInteger) n
{
   return( initWithObjects( self, objects, n));
}


- (id) initWithObject:(id) object
            arguments:(mulle_vararg_list) args
{
   NSUInteger   count;
   id           p;
   
   count = mulle_vararg_count( args, object);
   
   self = [self initWithCapacity:count];

   p = object;
   while( p)
   {
      add_object( self, p);
      p = mulle_vararg_next( args);
   }
   
   return( self);
}


- (instancetype) _initWithRetainedObjects:(id *) objects
                                    count:(NSUInteger) count
{
   return( initWithRetainedObjects( self, objects, count));
}


- (id) initWithObjects:(id) object, ...
{
   mulle_vararg_list   args;
   
   mulle_vararg_start( args, object);
   self = [self initWithObject:object
                     arguments:args];
   mulle_vararg_end( args);
   
   return( self);
}


- (id) initWithCapacity:(NSUInteger) capacity
{
   if( capacity)
   {
      self->_size    = capacity;
      self->_storage = MulleObjCObjectAllocateNonZeroedMemory( self, sizeof( id) * self->_size);
   }
   return( self);
}



#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSArray class]);
}


#pragma mark -
#pragma mark methods

static void   reserve(  NSMutableArray *self, size_t count)
{
   if( self->_count + count >= self->_size)
   {
      if( count < self->_size)
         count = self->_size;
      if( count < 8)
         count += 8;
      self->_size += count;
      self->_storage = MulleObjCObjectReallocateNonZeroedMemory( self, self->_storage, sizeof( id) * self->_size);
   }
}

//
// got no time, implement this "lamely" first
// do something cool later...
//
static void   add_object( NSMutableArray *self, id other)
{
   if( self->_count >= self->_size)
   {
      self->_size += self->_size;
      if( self->_size < 8)
         self->_size = 8;
      self->_storage = MulleObjCObjectReallocateNonZeroedMemory( self, self->_storage, sizeof( id) * self->_size);
   }
 
   self->_storage[ self->_count++] = [other retain];
   self->_mutationCount++;
}





- (void) addObject:(id) other
{
   add_object( self, other);
}


- (NSUInteger) count
{
   return( _count);
}


static void  assert_index( NSMutableArray *self, NSUInteger i)
{
   if( i >= self->_count)
      MulleObjCThrowInvalidIndexException( i);
}


static void  assert_index_1( NSMutableArray *self, NSUInteger i)
{
   if( i >= self->_count + 1)
      MulleObjCThrowInvalidIndexException( i);
}


- (id) objectAtIndex:(NSUInteger) i
{
   assert_index( self, i);
   return( _storage[ i]);
}


static NSUInteger  indexOfObjectIdenticalTo( NSMutableArray *self, id obj, NSRange range)
{
   NSUInteger   i, n;
   
   n = range.length + range.location;
   for( i = range.location; i < n; i++)
      if( self->_storage[ i] == obj)
         return( i);
   
   return( NSNotFound);
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
{
   return( indexOfObjectIdenticalTo( self, obj, NSMakeRange( 0, self->_count)));
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj 
                                inRange:(NSRange) range
{
   if( range.length + range.location > _count || range.length > _count)
      MulleObjCThrowInvalidRangeException( range);
   
   return( indexOfObjectIdenticalTo( self, obj, range));
}


static NSUInteger  indexOfObject( NSMutableArray *self, id obj, NSRange range, int pedantic)
{
   NSUInteger   i, n;
   BOOL         (*imp)( id, SEL, id);
   SEL          sel;
   
   // allow obj == nil
   if( ! obj || ! self->_count)
      return( NSNotFound);
      
   assert( [obj respondsToSelector:@selector( isEqual:)]);
   
   // quick check for first 32 pointers
   n = range.length;
   if( n > 32)
      n = 32;
   n += range.location;
   
   if( ! pedantic)
      for( i = range.location; i < n; i++)
         if( self->_storage[ i] == obj)
            return( i);
   
   sel = @selector( isEqual:);
   imp = (BOOL (*)()) [[obj self] methodForSelector:sel];  // resolve EOFault here

   n  = range.length + range.location;
   for( i = range.location; i < n; i++)
      if( (*imp)( obj, sel, self->_storage[ i]))
         return( i);
   
   return( NSNotFound);
}


- (BOOL) containsObject:(id) obj
{
   return( indexOfObject( self, obj, NSMakeRange( 0, self->_count), 0) != NSNotFound);
}


- (NSUInteger) indexOfObject:(id) obj
{
   return( indexOfObject( self, obj, NSMakeRange( 0, self->_count), 1));
}


- (NSUInteger) indexOfObject:(id) obj
                       inRange:(NSRange) range
{
   if( range.length + range.location > _count || range.length > _count)
      MulleObjCThrowInvalidRangeException( range);

   return( indexOfObject( self, obj, range, 1));
}


- (void) replaceObjectAtIndex:(NSUInteger) i
                   withObject:(id) object
{
   assert_index( self, i);

   [object retain];
   [_storage[ i] autorelease];
   
   _storage[ i] = object;
   _mutationCount++;
}


- (void) removeObjectAtIndex:(NSUInteger) i
{
   NSUInteger   n;
   assert_index( self, i);
   
   [_storage[ i] autorelease];
   
   n = _count - (i + 1);
   if( n)
      memcpy( &_storage[ i], &_storage[ i + 1], n * sizeof( id));
   --_count;
   
   _mutationCount++;
}


- (void) removeObjectsInRange:(NSRange) range
{
   NSUInteger   n;
   
   if( ! range.length)
      return;
      
   assert_index( self, range.location);
   assert_index( self, range.location + range.length - 1);
   
   n = _count - (range.location + range.length - 1);
   if( n)
   {
      _MulleObjCAutoreleaseObjects( &_storage[ range.location], range.length);

      memcpy( &_storage[ range.location], 
              &_storage[ range.location + range.length], 
              n * sizeof( id));
   }
   _count -= range.length;
   _mutationCount++;
}


- (void) removeLastObject
{
   if( ! _count)
      MulleObjCThrowInvalidRangeException( NSMakeRange( 0, 0));
   
   [_storage[ --_count] autorelease];
   
   if( _count < (_size >> 1) && _size > 8)
   {
      _size >>= 1;
      _storage = MulleObjCObjectReallocateNonZeroedMemory( self, _storage, sizeof( id) * _size);
   }
   _mutationCount++;
}


//
// idea: use a struct _mulle_autoreleasepointerarray as
// backing storage and just hand it en block over to the autorelease
// pool
//
- (void) removeAllObjects
{
   _MulleObjCAutoreleaseObjects( &_storage[ 0], _count);

   _count = 0;
   _mutationCount++;
}


- (void) removeObjectIdenticalTo:(id) obj
{
   NSUInteger   i;
   
   i = indexOfObjectIdenticalTo( self, obj, NSMakeRange( 0, self->_count));
   if( i != NSNotFound)
      [self removeObjectAtIndex:i];
}


- (void) removeObjectIdenticalTo:(id) obj 
                         inRange:(NSRange) range
{
   NSUInteger   i;
   
   i = indexOfObjectIdenticalTo( self, obj, range);
   if( i != NSNotFound)
      [self removeObjectAtIndex:i];
}


- (void) removeObjectsInArray:(NSArray *) otherArray
{
   NSUInteger   i, n;
   
   n = [otherArray count];
   for( i = 0; i < n; i++)
      [self removeObjectIdenticalTo:[otherArray objectAtIndex:i]];
}


#pragma mark -
#pragma mark objects access

- (void) getObjects:(id *) aBuffer
{
   memcpy( aBuffer, self->_storage, self->_count * sizeof( id)); 
  // _mutationCount++;
}


- (void) getObjects:(id *) aBuffer
              range:(NSRange) range
{
   if( range.length + range.location > _count || range.length > _count)
      MulleObjCThrowInvalidRangeException( range);
   memcpy( aBuffer, &self->_storage[ range.location], range.length * sizeof( id));
}

//
// coded by example from http://cocoawithlove.com/2008/05/implementing-countbyenumeratingwithstat.html
// 
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) state
                                   objects:(id *) stackbuf 
                                     count:(NSUInteger) len
{
   if( state->state)
      return( 0);
   
   state->state        = 1;
   state->itemsPtr     = self->_storage;
   state->mutationsPtr = &_mutationCount;
   
   return( self->_count);
}



- (void) addObjectsFromArray:(NSArray *) array
{
   size_t   length;
   
   length = [array count];
   reserve( self, length);
   
   [array getObjects:&self->_storage[ self->_count]];
   
   MulleObjCMakeObjectsPerformRetain( &self->_storage[ self->_count], length);
   
   self->_count += length;
   
   _mutationCount++;
}


// it's primitive though the dox don't say it
- (void) replaceObjectsInRange:(NSRange) range
                   withObjects:(id *) objects
                         count:(NSUInteger) n
{
   NSUInteger  i;
   NSUInteger  j;
   
   assert( range.length == n);
   assert( objects);
   
   if( range.length + range.location > _count || range.length > _count)
      MulleObjCThrowInvalidRangeException( range);

   _MulleObjCAutoreleaseObjects( &_storage[ range.location], range.length);
   
   n  = range.length + range.location;
   for( j = 0, i = range.location; i < n; i++, j++)
      self->_storage[ i] = [objects[ i] retain];
   
   _mutationCount++;
}


- (void) replaceObjectsInRange:(NSRange) aRange 
          withObjectsFromArray:(NSArray *) otherArray
{
   id           *tmp;
   NSUInteger   n;
   
   n   = [otherArray count];
   tmp = mulle_malloc( sizeof( id) * n);

   [otherArray getObjects:tmp];
   [self replaceObjectsInRange:aRange
                   withObjects:tmp
                         count:n];
   
   mulle_free( tmp);
}


- (void) replaceObjectsInRange:(NSRange) aRange 
          withObjectsFromArray:(NSArray *) otherArray 
                         range:(NSRange) otherRange
{
   id   *tmp;
   
   tmp = mulle_malloc( sizeof( id) * otherRange.length);
   [otherArray getObjects:tmp
                    range:otherRange];
   [self replaceObjectsInRange:aRange
                   withObjects:tmp
                         count:otherRange.length];
   mulle_free( tmp);
}


- (void) makeObjectsPerformSelector:(SEL) sel
{
   MulleObjCMakeObjectsPerformSelector( _storage, _count, sel, nil);
}


- (void) setArray:(NSArray *) other
{
   initWithArrayAndRange( self, other, NSMakeRange( 0, [other count]));
}


- (void) insertObject:(id) obj 
              atIndex:(NSUInteger) i
{
   NSUInteger   n;
   
   assert_index_1( self, i);
   if( i == self->_count)
   {
      add_object( self, obj);
      return;
   }
   
   if( _count >= _size)
   {
      self->_size += self->_size;
      if( self->_size < 8)
         self->_size = 8;
      _storage = MulleObjCObjectReallocateNonZeroedMemory( self, _storage, sizeof( id) * _size);
   }
         
   n = self->_count - i;
   memcpy( &_storage[ i + 1], &_storage[ i], n * sizeof( id));

   _storage[ i] = [obj retain];
   self->_count++;
   _mutationCount++;
}


//
// implement some more NSMutableArray stuff
//
- (void) exchangeObjectAtIndex:(NSUInteger) index1
             withObjectAtIndex:(NSUInteger) index2
{
   id   tmp;
   
   assert_index( self, index1);
   assert_index( self, index2);
   
   tmp             = _storage[ index1];
   _storage[ index1] = _storage[ index2];
   _storage[ index2] = tmp;

   _mutationCount++;
}


static int   bouncyBounceSel( void *a, void *b, void *ctxt)
{
   return( (int) mulle_objc_object_call( (id) a, (mulle_objc_methodid_t) ctxt, b));
}


- (void) sortUsingSelector:(SEL) sel
{
   mulle_qsort_pointers( (void **) _storage, _count, bouncyBounceSel, (void *) (intptr_t) sel);
   _mutationCount++;
}


typedef struct
{
   NSInteger   (*f)( id, id, void *);
   void        *ctxt;
} bouncy;


static int   bouncyBounce( void *a, void *b, void *_ctxt)
{
   bouncy  *ctxt;
   
   ctxt = _ctxt;
   return( (int) (ctxt->f)( (id) a, (id) b, ctxt->ctxt));
}


- (void) sortUsingFunction:(NSInteger (*)(id, id, void *)) f 
                   context:(void *) context
{
   bouncy  bounce;
   
   bounce.ctxt = context;
   bounce.f    = f;
   
   mulle_qsort_pointers( (void **) _storage, _count, bouncyBounce, &bounce);
   _mutationCount++;
}


- (id) copy
{
   return( (id) [[NSArray alloc] initWithArray:self]);
}

@end


@implementation NSArray( NSMutableCopying)

- (id) mutableCopy
{
   return( [[NSMutableArray alloc] initWithArray:self]);
}

@end


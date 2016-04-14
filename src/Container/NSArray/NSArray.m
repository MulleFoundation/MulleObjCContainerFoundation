/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSArray.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSArray.h"

#import "_MulleObjCArrayEnumerator.h"

// other files in this library
#import "_MulleObjCEmptyArray.h"
#import "_MulleObjCConcreteArray.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies


@implementation NSObject( NSArray)

- (BOOL) __isNSArray
{
   return( NO);
}

@end


@implementation NSArray

- (BOOL) __isNSArray
{
   return( YES);
}


# pragma mark -
# pragma mark class cluster

- (instancetype) initWithArray:(NSArray *) other
{
   return( [_MulleObjCConcreteArray newWithArray:other
                                       copyItems:NO]);
}


- (instancetype) initWithArray:(NSArray *) other
                         range:(NSRange) range
{
   if( ! range.length)
      return( [_MulleObjCEmptyArray sharedInstance]);
   
   return( [_MulleObjCConcreteArray newWithArray:other
                                           range:range]);
}


- (instancetype) initWithArray:(NSArray *) other
                     copyItems:(BOOL) flag
{
   return( [_MulleObjCConcreteArray newWithArray:other
                                       copyItems:flag]);
}


- (instancetype) initWithObject:(id) firstObject
                      arguments:(mulle_vararg_list) args
{
   [self release];

   //
   // subclass check falls on its face, because there is no defined
   // ..V method
   //
   if( ! firstObject)
      return( [_MulleObjCEmptyArray sharedInstance]);

   return( [_MulleObjCConcreteArray newWithObject:firstObject
                                        arguments:args]);
}

           
- (instancetype) initWithObjects:(id) firstObject, ...
{
   NSArray                  *array;
   mulle_vararg_list   args;

   //
   // subclass check falls on its face, because there is no defined
   // ..V method
   //
   if( ! firstObject)
      return( [_MulleObjCEmptyArray sharedInstance]);
   
   mulle_vararg_start( args, firstObject);
   array = [_MulleObjCConcreteArray newWithObject:firstObject
                                        arguments:args];
   mulle_vararg_end( args);
   
   return( array);
}


- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
{
   if( ! count)
      return( [_MulleObjCEmptyArray sharedInstance]);

   return( [_MulleObjCConcreteArray newWithObjects:objects
                                             count:count]);
}


- (instancetype) initWithArray:(NSArray *) other
                     andObject:(id) obj
{
   return( [[_MulleObjCConcreteArray newWithArray:other
                                        andObject:obj] autorelease]);
}


- (instancetype) initWithArray:(NSArray *) other
                      andArray:(NSArray *) other2
{
   return( [[_MulleObjCConcreteArray newWithArray:other
                                         andArray:other2] autorelease]);
}



//
// could optimize the next two, by a subclass that just "stacks" arrays
// (would be cool, if both are immutable
//
- (NSArray *) arrayByAddingObject:(id) obj
{
   return( [[_MulleObjCConcreteArray newWithArray:self
                                        andObject:obj] autorelease]);
}


- (NSArray *) arrayByAddingObjectsFromArray:(NSArray *) other
{
   return( [[_MulleObjCConcreteArray newWithArray:self
                                         andArray:other] autorelease]);
}


# pragma mark -
# pragma mark construction conveniences

+ (instancetype) array
{
   return( [[[self alloc] init] autorelease]);
}


+ (instancetype) arrayWithArray:(NSArray *) other
{
   return( [[[self alloc] initWithArray:other
                                  range:NSMakeRange( 0, [other count])] autorelease]);
}


+ (instancetype) arrayWithArray:(NSArray *) other
                          range:(NSRange) range
{
   return( [[[self alloc] initWithArray:other
                                  range:range] autorelease]);
}


+ (instancetype) arrayWithObject:(id) obj
{
   return( [[[self alloc] initWithObjects:&obj
                                    count:obj ? 1 : 0] autorelease]);
}


+ (instancetype) arrayWithObjects:(id) firstObject, ...
{
   mulle_vararg_list   args;
   NSArray                  *array;
   
   mulle_vararg_start( args, firstObject);
   array = [[[self alloc] initWithObject:firstObject
                               arguments:args] autorelease];
   mulle_vararg_end( args);
   
   return( array);
}


+ (id) arrayWithObjects:(id *) objects 
                  count:(NSUInteger) count
{
   return( [[[self alloc] initWithObjects:objects
                                    count:count] autorelease]);
}


# pragma mark -
# pragma mark xxx

- (id) firstObjectCommonWithArray:(NSArray *) other
{
   NSEnumerator   *rover;
   SEL             selNext;
   IMP             impNext;
   SEL             selContains;
   IMP             impContains;
   id              p;

   rover   = [self objectEnumerator];

   selNext = @selector( nextObject);
   impNext = [rover methodForSelector:selNext];

   selContains = @selector( isEqual:);
   impContains = [other methodForSelector:selContains];

   while( p = (*impNext)( rover, selNext, NULL))
      if( (*impContains)( other, selContains, p))
         break;

   return( p);
}


static NSUInteger  findIndexWithRangeForEquality( NSArray *self, NSRange range, id obj)
{
   NSUInteger   len;
   id           buf[ 64];
   id           *p;
   id           *sentinel;
   BOOL         (*impEqual)( id, SEL, id);
   SEL          selEqual;
   
   selEqual = @selector( isEqual:);
   impEqual = (void *) [obj methodForSelector:selEqual];

   for(;;)
   {
      len = range.length > sizeof( buf) / sizeof( id)  ? sizeof( buf) / sizeof( id) : range.length;
      if( ! len)
         break;
      
      [self getObjects:buf
                 range:NSMakeRange( range.location, len)];
      sentinel = &buf[ len];
      
      for( p = buf; p < sentinel; p++, range.location++)
         if( (*impEqual)( obj, selEqual, *p))
            return( range.location);
            
      range.length -= len;
   }
   return( NSNotFound);
}


static NSUInteger  findIndexWithRange( NSArray *self, NSRange range, id obj)
{
   NSUInteger   len;
   id           buf[ 64];
   id           *p;
   id           *sentinel;
   
   for(;;)
   {
      len = range.length > sizeof( buf) / sizeof( id)  ? sizeof( buf) / sizeof( id) : range.length;
      if( ! len)
         break;
      
      [self getObjects:buf
                 range:NSMakeRange( range.location, len)];
      sentinel = &buf[ len];
      
      for( p = buf; p < sentinel; p++, range.location++)
         if( *p == obj)
            return( range.location);
            
      range.length -= len;
   }
   return( NSNotFound);
}


- (NSUInteger) indexOfObject:(id) obj
{
   return( findIndexWithRangeForEquality( self, NSMakeRange( 0, [self count]), obj));
}


- (BOOL) containsObject:(id) obj
{
   return( NSNotFound != findIndexWithRangeForEquality( self, NSMakeRange( 0, [self count]), obj));
}


- (NSUInteger) indexOfObject:(id) obj 
                     inRange:(NSRange) range
{
   NSUInteger   count;
   
   count = [self count];
   MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( range, count);
   
   return( findIndexWithRangeForEquality( self, range, obj));
}

                     
- (NSUInteger) indexOfObjectIdenticalTo:(id) obj
{
   return( findIndexWithRange( self, NSMakeRange( 0, [self count]), obj));
}


- (NSUInteger) indexOfObjectIdenticalTo:(id) obj 
                                inRange:(NSRange) range
{
   NSUInteger   count;
   
   count = [self count];
   MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( range, count);
   
   return( findIndexWithRange( self, range, obj));
}
                                

- (BOOL) isEqual:(id) other
{
   if( ! other)
      return( NO);
   return( [self isEqualToArray:other]);
}


- (BOOL) isEqualToArray:(NSArray *) other
{
   NSUInteger     otherCount;
   NSUInteger     len;
   id             buf1[ 64];
   id             buf2[ 64];
   id             *sentinel;
   id             *p;
   id             *q;
   NSRange        range;
   
   range.length = [self count];
   otherCount   = [other count];
   
   if( range.length != otherCount)
      return( NO);
   
   range.location = 0;
   for(;;)
   {
      len = range.length > sizeof( buf1) / sizeof( id) ? sizeof( buf1) / sizeof( id) : range.length;
      if( ! len)
         break;
      
      [self getObjects:buf1
                 range:NSMakeRange( range.location, len)];
      [self getObjects:buf2
                 range:NSMakeRange( range.location, len)];
                 
      sentinel = &buf1[ len];
      for( q = buf2, p = buf1; p < sentinel; p++, q++)
         if( ! [*p isEqual:*q])
            return( NO);
            
      range.location += len;
      range.length   -= len;
   }
   return( YES);
}


- (NSUInteger) hash
{
   return( [[self lastObject] hash]);
}


- (id) lastObject
{
   NSUInteger   i;
   
   i = [self count];
   if( ! i)
      return( nil);
      
   return( [self objectAtIndex:i - 1]);
}


static void   perform( NSArray *self, NSRange range, SEL sel, id obj)
{
   NSUInteger   len;
   id           buf[ 64];

   assert( range.location + range.length <= [self count]);
   
   for(;;)
   {
      len = range.length > sizeof( buf) / sizeof( id)  ? sizeof( buf) / sizeof( id) : range.length;
      if( ! len)
         break;
      
      [self getObjects:buf
                 range:NSMakeRange( range.location, len)];
                 
      MulleObjCMakeObjectsPerformSelector( buf, len, sel, obj);
      range.location += len;
      range.length   -= len;
   }
}



- (void) makeObjectsPerformSelector:(SEL) sel
{
   perform( self, NSMakeRange( 0, [self count]), sel, nil);
}


- (void) makeObjectsPerformSelector:(SEL) sel 
                         withObject:(id) obj;
{
   perform( self, NSMakeRange( 0, [self count]), sel, obj);
}


- (void) _makeObjectsPerformSelector:(SEL) sel 
                               range:(NSRange) range;
{
   perform( self, range, sel, nil);
}



- (NSEnumerator *) objectEnumerator
{
   return( [_MulleObjCArrayEnumerator enumeratorWithArray:self]);
}


- (NSEnumerator *) reverseObjectEnumerator
{
   return( [MulleObjCArrayReverseEnumerator enumeratorWithArray:self]);
}


- (NSArray *) sortedArrayUsingFunction:(NSInteger (*)(id, id, void *)) f 
                               context:(void *) context
{
   return( [[_MulleObjCConcreteArray newWithArray:self
                                     sortFunction:f
                                          context:context] autorelease]);
}


- (NSArray *) sortedArrayUsingSelector:(SEL) comparator
{
   return( [[_MulleObjCConcreteArray newWithArray:self
                                 sortedBySelector:comparator] autorelease]);
}


- (NSArray *) subarrayWithRange:(NSRange) range
{
   return( [[[_MulleObjCConcreteArray alloc] initWithArray:self
                                                     range:range] autorelease]);
}


- (BOOL) containsObject:(id) other
                inRange:(NSRange) range
{
   return( [self indexOfObject:other
                       inRange:range] != NSNotFound);
}


- (void) getObjects:(id *)objects
{
   [self getObjects:objects
              range:NSMakeRange( 0, [self count])];
}

#if 0
- (id) debugDescription
{
   NSMutableString   *s;
   NSEnumerator      *rover;
   BOOL              flag;
   id                p;
   
   flag = NO;
   s = [NSMutableString stringWithString:@"("];
   rover = [self objectEnumerator];
   while( p = [rover nextObject])
   {
      if( flag)
         [s appendString:@", "];
      flag = YES;
      
      [s appendString:[p debugDescription]];
   }
   [s appendString:@")"];
   return( s);
}
#endif


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




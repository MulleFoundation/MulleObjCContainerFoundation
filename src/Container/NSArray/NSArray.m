//
//  NSArray.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSArray.h"

#import "_MulleObjCArrayEnumerator.h"

// other files in this library
#import "_MulleObjCEmptyArray.h"
#import "_MulleObjCConcreteArray.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies

#pragma clang diagnostic ignored "-Wprotocol"


@implementation NSObject( _NSArray)

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
   [self release];

   return( [_MulleObjCConcreteArray newWithArray:other
                                       copyItems:NO]);
}


- (instancetype) initWithArray:(NSArray *) other
                         range:(NSRange) range
{
   [self release];

   if( ! range.length)
      return( [[_MulleObjCEmptyArray sharedInstance] retain]);

   return( [_MulleObjCConcreteArray newWithArray:other
                                           range:range]);
}


- (instancetype) initWithArray:(NSArray *) other
                     copyItems:(BOOL) flag
{
   [self release];

   return( [_MulleObjCConcreteArray newWithArray:other
                                       copyItems:flag]);
}


- (instancetype) initWithObject:(id) firstObject
                     varargList:(va_list) args
{
   [self release];

   //
   // subclass check falls on its face, because there is no defined
   // ..V method
   //
   if( ! firstObject)
      return( [[_MulleObjCEmptyArray sharedInstance] retain]);

   return( [_MulleObjCConcreteArray newWithObject:firstObject
                                       varargList:args]);
}

- (instancetype) initWithObject:(id) firstObject
                mulleVarargList:(mulle_vararg_list) args
{
   [self release];

   //
   // subclass check falls on its face, because there is no defined
   // ..V method
   //
   if( ! firstObject)
      return( [[_MulleObjCEmptyArray sharedInstance] retain]);

   return( [_MulleObjCConcreteArray newWithObject:firstObject
                                 mulleVarargList:args]);
}


- (instancetype) initWithObjects:(id) firstObject, ...
{
   NSArray            *array;
   mulle_vararg_list   args;

   [self release];

   //
   // subclass check falls on its face, because there is no defined
   // ..V method
   //
   if( ! firstObject)
      return( [[_MulleObjCEmptyArray sharedInstance] retain]);

   mulle_vararg_start( args, firstObject);
   array = [_MulleObjCConcreteArray newWithObject:firstObject
                                        mulleVarargList:args];
   mulle_vararg_end( args);

   return( array);
}


- (instancetype) initWithObjects:(id *) objects
                           count:(NSUInteger) count
{
   [self release];

   if( ! count)
      return( [[_MulleObjCEmptyArray sharedInstance] retain]);

   return( [_MulleObjCConcreteArray newWithObjects:objects
                                             count:count]);
}


- (instancetype) _initWithRetainedObjects:(id *) objects
                                    count:(NSUInteger) count
{
   [self release];

   if( ! count)
      return( [[_MulleObjCEmptyArray sharedInstance] retain]);

   return( [_MulleObjCConcreteArray newWithRetainedObjects:objects
                                                     count:count]);
}


- (instancetype) initWithArray:(NSArray *) other
                     andObject:(id) obj
{
   [self release];

   return( [[_MulleObjCConcreteArray newWithArray:other
                                        andObject:obj] autorelease]);
}


- (instancetype) initWithArray:(NSArray *) other
                      andArray:(NSArray *) other2
{
   [self release];

   return( [[_MulleObjCConcreteArray newWithArray:other
                                         andArray:other2] autorelease]);
}


#pragma mark -
#pragma mark NSCopying


// done by returning self in protocol already, NSMutableArray must override


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
   NSArray             *array;

   mulle_vararg_start( args, firstObject);
   array = [[[self alloc] initWithObject:firstObject
                         mulleVarargList:args] autorelease];
   mulle_vararg_end( args);

   return( array);
}


+ (instancetype) arrayWithObjects:(id *) objects
                  count:(NSUInteger) count
{
   return( [[[self alloc] initWithObjects:objects
                                    count:count] autorelease]);
}


+ (instancetype) arrayWithRetainedObjects:(id *) objects
                          count:(NSUInteger) count
{
   return( [[[self alloc] _initWithRetainedObjects:objects
                                             count:count] autorelease]);
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
   impEqual = (BOOL (*)(id, SEL, id)) [obj methodForSelector:selEqual];

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



#pragma mark - hash and equality

- (NSUInteger) hash
{
   return( [[self lastObject] hash]);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSArray])
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


#pragma mark - accessors

// need @alias for this
- (id) :(NSUInteger) i
{
   return( [self objectAtIndex:i]);
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


#pragma mark -
#pragma mark enumeration

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


#if DEBUG

- (instancetype) retain
{
   return( [super retain]);
}


- (instancetype) autorelease
{
   return( [super autorelease]);
}


- (void) release
{
   [super release];
}

#endif

@end

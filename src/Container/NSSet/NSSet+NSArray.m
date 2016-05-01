/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSSet+NSArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSSet+NSArray.h"

// other files in this library
#import "NSArray.h"
#import "NSEnumerator.h"
#import "NSMutableArray.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationData.h"

// std-c and dependencies


@implementation NSSet( NSArray)

+ (id) setWithArray:(NSArray *) array
{
   return( [[[self alloc] initWithArray:array] autorelease]);
}


- (id) initWithArray:(NSArray *) array
{
   NSMutableData   *data;
   NSUInteger      count;
   id              *buf;
   
   count = [array count];
   if( ! count)
      return( [self init]);
      
   data = [NSMutableData dataWithLength:sizeof( id) * count];
   buf  = (id *) [data mutableBytes];
   [array getObjects:buf];
   return( [self initWithObjects:buf
                           count:count]);
}


- (NSArray *) allObjects
{
   NSMutableArray   *array;
   NSEnumerator     *rover;
   id               obj;
   
   array = [NSMutableArray array];
   rover = [self objectEnumerator];
   while( obj = [rover nextObject])
      [array addObject:obj];

   return( array);
}


- (void) makeObjectsPerformSelector:(SEL) sel
{
   [[self objectEnumerator] makeObjectsPerformSelector:sel];
}


- (void) makeObjectsPerformSelector:(SEL) sel 
                         withObject:(id) obj
{
   [[self objectEnumerator] makeObjectsPerformSelector:sel
                                            withObject:obj];
}


- (id) setByAddingObjectsFromArray:(NSArray *) array
{
   NSSet  *set;

   set = [NSSet setWithObjects:array];
   return( [self setByAddingObjectsFromSet:set]);
}

@end

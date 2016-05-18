/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSDictionary+NSArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSDictionary+NSArray.h"

// other files in this library
#import "NSArray.h"
#import "NSEnumerator.h"
#import "NSEnumerator+NSArray.h"
#import "NSMutableArray.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies



@implementation NSDictionary( NSArray)

+ (id) dictionaryWithObjects:(NSArray *) objects 
                     forKeys:(NSArray *) keys
{
   return( [[[self alloc] initWithObjects:objects
                                  forKeys:keys] autorelease]);
}

- (id) initWithObjects:(NSArray *) objects
               forKeys:(NSArray *) keys
{
   NSUInteger     count;
   id             *buf;
   id             *tofree;
   NSDictionary   *dictionary;
   size_t         size;
   
   count = [objects count];
   if( count != [keys count])
      MulleObjCThrowInvalidArgumentException( @"mismatched keys lengths");

   tofree = NULL;
   size   =  sizeof( id) * 2 * count;
   if( size <= 0x400)
      buf = alloca( size);
   else
      tofree = buf = mulle_malloc( size);
   
   [objects getObjects:buf];
   [keys getObjects:&buf[ count]];

   dictionary = [self initWithObjects:buf
                              forKeys:&buf[ count]
                                 count:count];
   mulle_free( tofree);

   return( dictionary);
}
               

- (NSArray *) keysSortedByValueUsingSelector:(SEL) comparator
{
   NSArray  *array;
   
   array = [[self keyEnumerator] allObjects];
   return( [array sortedArrayUsingSelector:comparator]);

}

- (NSArray *) objectsForKeys:(NSArray *) keys 
              notFoundMarker:(id) anObject
{
   NSEnumerator    *rover;
   NSMutableArray  *array;
   id              value;
   id              key;
   
   array = [NSMutableArray array];
   
   rover = [keys objectEnumerator];
   while( key = [rover nextObject])
   {
      value = [self objectForKey:key];
      if( value)  
         [array addObject:value];
   }
   return( array);
}


// TODO: code this less lazily in subclasses!
- (NSArray *) allKeys
{
   return( [[self keyEnumerator] allObjects]);
}


- (NSArray *) allKeysForObject:(id) anObject
{
   NSEnumerator    *rover;
   NSMutableArray  *array;
   id              value;
   id              key;
   
   array = [NSMutableArray array];
   
   rover = [self keyEnumerator];
   while( key = [rover nextObject])
   {
      value = [self objectForKey:key];
      if( [value isEqual:anObject])  
         [array addObject:key];
   }
   return( array);
}


- (NSArray *) allValues
{
   return( [[self objectEnumerator] allObjects]);
}

#pragma mark -
#pragma mark non-abstract

@end



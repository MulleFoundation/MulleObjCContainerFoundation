/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSDictionary.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSDictionary.h"

// other files in this library
#import "NSEnumerator.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies



@implementation NSDictionary 

+ (id) dictionary
{
   return( [[[self alloc] init] autorelease]);
}


+ (id) dictionaryWithDictionary:(NSDictionary *) other
{
   return( [[[self alloc] initWithDictionary:other] autorelease]);
}


+ (id) dictionaryWithObject:(id) obj
                     forKey:(id) key
{
   return( [[[self alloc] initWithObjects:&obj
                                  forKeys:&key
                                    count:1] autorelease]);
}


+ (id) dictionaryWithObjectsAndKeys:(id) object, ...
{
   NSDictionary             *dictionary;
   mulle_vararg_list   args;

   mulle_vararg_start( args, object);
   
   dictionary = [[[self alloc] initWithObject:object
                                    arguments:args] autorelease];
   mulle_vararg_end( args);
   return( dictionary);
}


//
// should also work for NSMutableArray
//
+ (id) dictionaryWithObjects:(id *) objects
                     forKeys:(id *) keys
                       count:(NSUInteger) count
{
   return( [[[self alloc] initWithObjects:objects
                                  forKeys:keys
                                    count:count] autorelease]);
}


- (id) anyKey
{
   return( [[self keyEnumerator] nextObject]);
}
 
 
- (id) anyObject
{
   return( [[self objectEnumerator] nextObject]);
}

 
- (NSUInteger) hash
{
   return( [[self anyObject] hash]);
}


- (BOOL) isEqualToDictionary:(NSDictionary *) other
{
   NSUInteger       count;
   NSEnumerator     *rover;
   id               key;
   id               value;
   id               other_value;
   
   if( other == self)
      return( YES);
      
   count = [self count];
   if( count != [other count])
      return( NO);
      
   if( ! count)
      return( YES);
      
   rover = [self keyEnumerator];
   while( key = [rover nextObject])
   {
      other_value = [other objectForKey:key];
      if( ! other_value)
         return( NO);
      
      value = [self objectForKey:key];
      if( other_value == value)
         continue;
      
      if( [other_value hash] != [value hash])
         return( NO);
      if( ! [other_value isEqual:value])
         return( NO);
   }
   return( YES);
}

@end


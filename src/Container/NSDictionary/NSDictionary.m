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
#import "_MulleObjCDictionary.h"
#import "_MulleObjCConcreteDictionary.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies

@interface NSDictionary( NSCoder)

@end


@implementation NSObject( _NSString)

- (BOOL) __isNSDictionary
{
   return( NO);
}

@end


@implementation NSDictionary 


- (BOOL) __isNSDictionary
{
   return( YES);
}


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
   NSDictionary        *dictionary;
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


#pragma mark -
#pragma mark class cluster inits

- (instancetype) init
{
   [self release];
   return( [_MulleObjCConcreteDictionary new]);
}


- (instancetype) initWithDictionary:(id) other
{
   [self release];
   return( [_MulleObjCConcreteDictionary newWithDictionary:other]);
}


- (instancetype) initWithObjects:(id *) obj
                         forKeys:(id *) key
                           count:(NSUInteger) count
{
   [self release];
   return( [_MulleObjCConcreteDictionary newWithObjects:obj
                                                forKeys:key
                                                  count:count]);
}


- (instancetype) initWithDictionary:(id) other
                          copyItems:(BOOL) copy
{
   [self release];
   return( [_MulleObjCConcreteDictionary newWithDictionary:other
                                                 copyItems:copy]);
}


- (instancetype) initWithObject:(id) obj
                      arguments:(mulle_vararg_list) args
{
   [self release];
   return( [_MulleObjCConcreteDictionary newWithObject:obj
                                             arguments:args]);
}


#pragma mark -
#pragma mark generic inits

- (instancetype) initWithObjectsAndKeys:(id) obj, ...
{
   mulle_vararg_list   args;
   id                  dictionary;
   
   mulle_vararg_start( args, obj);
   dictionary = [self initWithObject:obj
                           arguments:args];
   mulle_vararg_end( args);
   return( dictionary);
}


#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSDictionary class]);
}


- (id) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   [self release];
   return( [_MulleObjCConcreteDictionary _allocWithCapacity:count]);
}


- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           *keys;
   id           *values;
   id           *p;
   id           *q;
   id           *sentinel;
   size_t       size;
   
   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   
   size   = count * sizeof( id) * 2;
   keys   = MulleObjCObjectAllocateNonZeroedMemory( self, size);
   values = &keys[ count];

   p        = keys;
   q        = values;
   sentinel = &p[ count];
   while( p < sentinel)
   {
      [coder decodeValueOfObjCType:@encode( id)
                                at:p];
      [coder decodeValueOfObjCType:@encode( id)
                                at:q];
      ++p;
      ++q;
   }
   
   // ugliness
   [(id <_MulleObjCDictionary>) self  _setObjects:values
                                             keys:keys
                                            count:count];

   MulleObjCMakeObjectsPerformRelease( keys, count * 2);
   MulleObjCObjectDeallocateMemory( self, keys);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSUInteger     count;
   NSEnumerator   *rover;
   id             key;
   id             value;
   
   count = (NSUInteger) [self count];
   [coder encodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   rover = [self keyEnumerator];
   while( key = [rover nextObject])
   {
      value = [self objectForKey:key];
      [coder encodeObject:key];
      [coder encodeObject:value];
   }
}


- (id) copy
{
   return( [self retain]);
}


#pragma mark -
#pragma mark accessors


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

#pragma mark -
#pragma mark operations

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


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSDictionary])
      return( NO);
   return( [self isEqualToDictionary:other]);
}

@end


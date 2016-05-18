/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMutableDictionary.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSMutableDictionary.h"

// other files in this library
#import "_MulleObjCConcreteMutableDictionary.h"
#import "MulleObjCContainerCallback.h"
#import "NSEnumerator.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


#define NSDictionaryCallback           ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueRetainCallback)
#define NSDictionaryCopyValueCallback  ((struct mulle_container_keyvaluecallback *) &_MulleObjCContainerObjectKeyCopyValueCopyCallback)


@implementation NSObject( _NSMutableDictionary)

- (BOOL) __isNSMutableDictionary
{
   return( NO);
}

@end


@implementation NSMutableDictionary

- (BOOL) __isNSMutableDictionary
{
   return( YES);
}



+ (id) dictionaryWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


# pragma mark -
# pragma mark classcluster inits

- (instancetype) init
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary new]);
}


- (instancetype) initWithCapacity:(NSUInteger) capacity
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithCapacity:capacity]);
}


- (instancetype) initWithDictionary:(id) other
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithDictionary:other]);
}


- (instancetype) initWithObjects:(id *) obj
                         forKeys:(id *) key
                           count:(NSUInteger) count
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithObjects:obj
                                                       forKeys:key
                                                         count:count]);
}


- (instancetype) initWithDictionary:(id) other
                          copyItems:(BOOL) copy
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithDictionary:other
                                                        copyItems:copy]);
}


- (instancetype) initWithObject:(id) obj
                      arguments:(mulle_vararg_list) args
{
   [self release];
   return( [_MulleObjCConcreteMutableDictionary newWithObject:obj
                                                   arguments:args]);
}

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSDictionary class]);
}


#pragma mark - 
#pragma mark generic operations

- (void) addEntriesFromDictionary:(NSDictionary *) other
{
   NSEnumerator   *rover;
   id             key;
   id             value;
   
   rover = [other keyEnumerator];
   while( key = [rover nextObject])
   {
      value = [other objectForKey:key];
      [self setObject:value
      forKey:key];
   }
}


- (void) setDictionary:(NSDictionary *) other
{
   [self removeAllObjects];
   [self addEntriesFromDictionary:other];
}


- (id) copy
{
   return( (id) [[NSDictionary alloc] initWithDictionary:self]);
}

@end


@implementation NSDictionary ( NSMutableDictionary) 

- (id) mutableCopy
{
   return( [[NSMutableDictionary alloc] initWithDictionary:self]);
}

@end



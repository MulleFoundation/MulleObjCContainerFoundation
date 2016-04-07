/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMutableDictionary+NSArray.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSMutableDictionary+NSArray.h"

#import "NSArray.h"


@implementation NSMutableDictionary( NSArray)

- (void) removeObjectsForKeys:(NSArray *) array
{
   NSEnumerator   *rover;
   id             key;
   
   rover = [array objectEnumerator];
   while( key = [rover nextObject])
      [self removeObjectForKey:key];
}

@end



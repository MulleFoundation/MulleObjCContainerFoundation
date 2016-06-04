/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSEnumerator.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSEnumerator.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSEnumerator
@end


@implementation NSEnumerator( Perform)

- (void) makeObjectsPerformSelector:(SEL) sel
{
   id   obj;
   
   while( obj = [self nextObject])
      [obj performSelector:sel];
}


- (void) makeObjectsPerformSelector:(SEL) sel
                         withObject:(id) argument
{
   id   obj;
   
   while( obj = [self nextObject])
      [obj performSelector:sel
                withObject:argument];
}

@end

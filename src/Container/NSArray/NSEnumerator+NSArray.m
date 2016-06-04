/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSEnumerator+NSArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSEnumerator+NSArray.h"

#import "NSArray.h"
#import "NSMutableArray.h"



@implementation NSEnumerator( NSArray)

- (NSArray *) allObjects
{
   NSMutableArray  *array;
   IMP             impNext;
   SEL             selNext;
   IMP             impAdd;
   SEL             selAdd;
   id              obj;
   
   array = [NSMutableArray array];

   selNext = @selector( nextObject);
   impNext = [self methodForSelector:selNext];

   selAdd = @selector( addObject:);
   impAdd = [array methodForSelector:selAdd];

   while( obj = (*impNext)( self, selNext, NULL))
      (*impAdd)( array, selAdd, obj);
   
   return( array);
}


- (void) makeObjectsPerformSelector:(SEL) sel
{
   IMP   impNext;
   SEL   selNext;
   id    obj;
   
   selNext = @selector( nextObject);
   impNext = [self methodForSelector:selNext];

   while( obj = (*impNext)( self, selNext, NULL))
      [obj performSelector:sel];
}


- (void) makeObjectsPerformSelector:(SEL) sel
                         withObject:(id) argument
{
   IMP   impNext;
   SEL   selNext;
   id    obj;
   
   selNext = @selector( nextObject);
   impNext = [self methodForSelector:selNext];
   
   while( obj = (*impNext)( self, selNext, NULL))
      [obj performSelector:sel
                withObject:argument];
}

@end

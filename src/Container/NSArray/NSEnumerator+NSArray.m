//
//  NSEnumerator+NSArray.m
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
#pragma clang diagnostic ignored "-Wparentheses"

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


- (void) mulleMakeObjectsPerformSelector:(SEL) sel
                              withObject:(id) argument
                              withObject:(id) argument2
{
   id   obj;

   while( obj = [self nextObject])
      [obj performSelector:sel
                withObject:argument
                withObject:argument2];
}

@end

//
//  NSSet+NSArray.m
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
#import "NSSet+NSArray.h"

// other files in this library
#import "NSArray.h"
#import "NSEnumerator.h"
#import "NSMutableArray.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationData.h"

// std-c and dependencies


@implementation NSSet( NSArray)

+ (instancetype) setWithArray:(NSArray *) array
{
   return( [[[self alloc] initWithArray:array] autorelease]);
}


- (instancetype) initWithArray:(NSArray *) array
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


- (NSSet *) setByAddingObjectsFromArray:(NSArray *) array
{
   NSSet  *set;

   set = [NSSet setWithObjects:array];
   return( [self setByAddingObjectsFromSet:set]);
}

@end

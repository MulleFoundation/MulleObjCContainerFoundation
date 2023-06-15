//
//  NSDictionary+NSArray.m
//  MulleObjCContainerFoundation
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
#import "NSDictionary+NSArray.h"

// other files in this library
#import "NSArray.h"
#import "NSEnumerator.h"
#import "NSEnumerator+NSArray.h"
#import "NSMutableArray.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies
#import "import-private.h"


@implementation NSDictionary( NSArray)

+ (instancetype) dictionaryWithObjects:(NSArray *) objects
                               forKeys:(NSArray *) keys
{
   return( [[[self alloc] initWithObjects:objects
                                  forKeys:keys] autorelease]);
}

- (instancetype) initWithObjects:(NSArray *) objects
                         forKeys:(NSArray *) keys
{
   NSUInteger     count;
   NSDictionary   *dictionary;
   size_t         size;

   count = [objects count];
   if( count != [keys count])
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "mismatched keys/objects lengths");

   size = 2 * count;
   mulle_flexarray_do_id( buf, 32, size)
   {
      [objects getObjects:buf];
      [keys getObjects:&buf[ count]];

      dictionary = [self initWithObjects:buf
                                 forKeys:&buf[ count]
                                    count:count];
   }

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
   NSMutableArray  *array;
   id              value;
   id              key;

   array = [NSMutableArray array];
   for( key in keys)
   {
      value = [self objectForKey:key];
      value = value ? value : anObject;
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
   NSMutableArray   *array;
   id               value;
   id               key;

   array = [NSMutableArray array];

   for( key in self)
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

#pragma mark - non-abstract

@end

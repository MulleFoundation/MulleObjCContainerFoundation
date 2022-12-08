//
//  NSMutableArray+NSSet.m
//  MulleObjCContainerFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  Copyright (c) 2020 Codeon GmbH.
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

#import "NSMutableArray+NSSet.h"

// other files in this library
#import "NSSet+NSArray.h"

// other libraries of MulleObjCContainerFoundation

// std-c and dependencies


@implementation NSMutableArray (NSSet)


//
// The general expectation of this algorithm is, that the objects in
// otherArray are more likely to be part of self than not.
//
- (void) removeObjectsInArray:(NSArray *) otherArray
{
   id           obj;
   NSUInteger   i, n;
   NSUInteger   m;
   IMP          IMPGet;
   IMP          IMPRemove;
   IMP          IMPMember;
   SEL          SELMember;
   id           testContainer;
   NSUInteger   loops;

   if( otherArray == self)
   {
      [self removeAllObjects];
      return;
   }

   m = [otherArray count];
   n = [self count];

   //
   // overflow can't happen, because counts are max 30 bits on 32 bit
   // and 61 bit on 64 bit, meaning 30bit * 30bit  = 60bit result
   loops = m * n;

   //
   // For small loops, just don't bother
   // (MEMO: constants are picked out of nowhere)
   //
   if( loops <= 32 * 32)
   {
      IMPRemove = [self methodForSelector:@selector( removeObject:)];
      for( obj in otherArray)
         MulleObjCIMPCall( IMPRemove, self, @selector( removeObject:), obj);
      return;
   }

   // if other is very small, a set usually doesn't pay off. Picking a good
   // constant here is important.
   if( m >= 16)
   {
      testContainer = [NSSet setWithArray:otherArray];
      SELMember     = @selector( member:);
   }
   else
   {
      testContainer = otherArray;
      SELMember     = @selector( containsObject:);
   }

   IMPMember = [testContainer methodForSelector:SELMember];

   //
   // Depending on the amount of removes, an intermediate copy could be useful,
   // as each remove is done with a memmove. memmove can be good though,
   // if there are few removals.
   //
   // So lets' estimate how much stuff we remove from our array, if
   // we do more than 1/4 and the array isn't puny, then we create a new
   // array instead.
   //
   if( n >= 128 && m >= n / 4)
   {
      id   *tmp;
      id   *p;
      id   *sentinel;
      id   *q;

      tmp      = MulleObjCInstanceAllocateNonZeroedMemory( self, sizeof( id) * n);
      q        = tmp;
      p        = _storage;
      sentinel = &p[ _count];
      while( p < sentinel)
      {
         if( MulleObjCIMPCall( IMPMember, testContainer, SELMember, *p))
            [*p autorelease];
         else
            *q++ = *p;
         ++p;
      }
      MulleObjCInstanceDeallocateMemory( self, _storage);

      _storage = tmp;
      _count   = q - tmp;
      _size    = n;
      _mutationCount++;
      return;
   }

   IMPRemove = [self methodForSelector:@selector( removeObjectAtIndex:)];
   IMPGet    = [self methodForSelector:@selector( objectAtIndex:)];

   //
   // Remove from back to front so we don't have to so much copying.
   //
   for( i = n; i;)
   {
      --i;
      obj = MulleObjCIMPCall( IMPGet, self, @selector( objectAtIndex:), (id) i);
      if( ! MulleObjCIMPCall( IMPMember, testContainer, SELMember, obj))
         continue;

      MulleObjCIMPCall( IMPRemove, self, @selector( removeObjectAtIndex:), (id) i);
   }
}

@end


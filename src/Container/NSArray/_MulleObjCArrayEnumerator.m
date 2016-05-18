//
//  MulleObjCArrayEnumerator.m
//  MulleObjCFoundation
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCArrayEnumerator.h"

#import "NSArray.h"


@implementation _MulleObjCArrayEnumerator

+ (instancetype) enumeratorWithArray:(NSArray *) owner
{
   _MulleObjCArrayEnumerator   *rover;
   
   rover = NSAllocateObject( self, 0, NULL);
   
   rover->_range  = NSMakeRange( 0, [owner count]);
   rover->_owner  = [owner retain];

   return( [rover autorelease]);
}


- (void) dealloc
{
   [_owner release];
   
   [super dealloc];
}


- (id) nextObject
{
   if( _range.location >= _range.length)
      return( nil);
   
   return( [_owner objectAtIndex:_range.location++]);
}

@end



@implementation MulleObjCArrayReverseEnumerator

- (id) nextObject
{
   if( _range.location >= _range.length)
      return( nil);
   
   return( [_owner objectAtIndex:_range.length - ++_range.location]);
}

@end


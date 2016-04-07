/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSValue+Private.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */

@interface NSValue ( _Private)

- (NSUInteger) _size;

@end


// a bit tricky, MulleObjCGenericValue varies with the content size and
// the size of the @encoding string which has to be copied
//
@interface _MulleObjCConcreteValue : NSValue
{
   NSInteger   _size;
}
@end


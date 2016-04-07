/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSConstantString.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_NSConstantString.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSConstantString

//
// weird shit: http://lists.apple.com/archives/objc-language/2006/Jan/msg00013.html
// 

- (utf8char *) _fastUTF8StringContents
{
   return( _storage);
}


- (NSUInteger) _UTF8StringLength
{
   return( _length);
}


- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (NSUInteger) length
{
   return( _length);
}

@end



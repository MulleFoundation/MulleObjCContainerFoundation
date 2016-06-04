/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSArray+Private.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
@interface NSArray( _Private)


- (id) _initWithArray:(NSArray *) other
                range:(NSRange) range;           
- (void) _makeObjectsPerformSelector:(SEL) sel 
                               range:(NSRange) range;
+ (id) _arrayWithArray:(NSArray *) other
                 range:(NSRange) range;
                 
@end


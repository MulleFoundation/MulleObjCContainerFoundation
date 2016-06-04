/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSEnumerator.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import <MulleObjC/MulleObjC.h>


@interface NSEnumerator : NSObject
@end


@interface NSEnumerator( Subclasses)

- (id) nextObject;

@end



@interface NSEnumerator( Perform)

- (void) makeObjectsPerformSelector:(SEL) sel;
- (void) makeObjectsPerformSelector:(SEL) sel
                         withObject:(id) obj;

@end

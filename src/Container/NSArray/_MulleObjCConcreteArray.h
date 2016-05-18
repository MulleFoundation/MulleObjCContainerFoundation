/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  MulleObjCConcreteArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSArray.h"


//
// you should not subclass _MulleObjCConcreteArray
// because there is extra data behind _count
//
@interface _MulleObjCConcreteArray : NSArray
{
   size_t   _count;
}

+ (id) newWithObjects:(id *) objects
                count:(NSUInteger) count;

+ (id) newWithRetainedObjects:(id *) objects
                        count:(NSUInteger) count;

+ (id) newWithArray:(NSArray *) other
           copyItems:(BOOL) flag;

+ (id) newWithObject:(id) firstObject
           arguments:(mulle_vararg_list) args;

+ (id) newWithArray:(NSArray *) other
          andObject:(id) obj              __attribute__(( ns_returns_retained));

+ (id) newWithArray:(NSArray *) other
           andArray:(NSArray *) other2;

+ (id) newWithArray:(NSArray *) other
              range:(NSRange) range;

+ (id) newWithArray:(NSArray *) other
   sortedBySelector:(SEL) sel;

+ (id) newWithArray:(NSArray *) other
       sortFunction:(NSInteger (*)( id, id, void *)) f
            context:(void *) context;

// used for NSCoder
+ (id) _allocWithCapacity:(NSUInteger) count;

@end


/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSDictionary.h is a part of MulleFoundation
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


@class NSEnumerator;


@interface NSDictionary : NSObject < NSCopying, MulleObjCClassCluster>

+ (id) dictionary;
+ (id) dictionaryWithDictionary:(NSDictionary *) dictionary;
+ (id) dictionaryWithObject:(id) anObject 
                     forKey:(id) aKey;
+ (id) dictionaryWithObjects:(id *) objects 
                     forKeys:(id *) keys 
                       count:(NSUInteger) count;
+ (id) dictionaryWithObjectsAndKeys:(id) firstObject , ...;

- (id) initWithDictionary:(NSDictionary *) otherDictionary;
- (id) initWithDictionary:(NSDictionary *) otherDictionary 
                copyItems:(BOOL) flag;
- (id) initWithObjects:(id *) objects 
               forKeys:(id *) keys 
                 count:(NSUInteger) count;
- (id) initWithObjectsAndKeys:(id)firstObject , ...;
- (id) initWithObject:(id) object
            arguments:(mulle_vararg_list) args;


- (BOOL) isEqualToDictionary:(NSDictionary *) other;

@end



@interface NSDictionary( Subclasses)

- (NSUInteger) count;
- (void) getObjects:(id *) objects 
            andKeys:(id *) keys;

- (id) objectForKey:(id) key;
- (NSEnumerator *) keyEnumerator;
- (NSEnumerator *) objectEnumerator;

@end

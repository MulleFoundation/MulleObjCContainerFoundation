//
//  _MulleObjCConcreteMutableDictionary.m
//  MulleObjCFoundation
//
//  Created by Nat! on 02.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteMutableDictionary.h"


@implementation _MulleObjCConcreteMutableDictionary


+ (instancetype) newWithCapacity:(NSUInteger) capacity
{
   return( (id) _MulleObjCNewDictionaryWithCapacity( self, capacity));
}


- (void) setObject:(id) obj
            forKey:(NSObject <NSCopying> *) key
{
   _MulleObjCDictionaryIvars    *ivars;
   struct mulle_pointerpair    pair;
   
   assert( [key respondsToSelector:@selector( copy)]);
   assert( [key respondsToSelector:@selector( hash)]);
   assert( [key respondsToSelector:@selector( isEqual:)]);
   assert( [obj respondsToSelector:@selector( retain)]);
   
   ivars = getDictionaryIvars( self);
   pair._key   = key;
   pair._value = obj;
   _mulle_map_set( &ivars->_table, &pair, NSDictionaryCallback, ivars->_allocator);
}


- (void) removeObjectForKey:(id) key
{
   _MulleObjCDictionaryIvars    *ivars;

   ivars = getDictionaryIvars( self);
   _mulle_map_remove( &ivars->_table, key, NSDictionaryCallback, ivars->_allocator);
}


- (void) removeAllObjects
{
   _MulleObjCDictionaryIvars    *ivars;

   ivars = getDictionaryIvars( self);
   _mulle_map_reset( &ivars->_table, NSDictionaryCallback, ivars->_allocator);
}

@end

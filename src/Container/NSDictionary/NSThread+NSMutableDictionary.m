//
//  NSThread+NSDictionary.m
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSThread+NSMutableDictionary.h"


@implementation NSThread (NSDictionary)

- (NSMutableDictionary *) threadDictionary
{
   if(  _userInfo)
      _userInfo = [NSMutableDictionary new];
   return( _userInfo);
}

@end

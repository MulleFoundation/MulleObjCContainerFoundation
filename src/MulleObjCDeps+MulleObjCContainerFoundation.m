//
//  MulleObjCDeps+Foundation.m
//  MulleObjCContainerFoundation
//
//  Created by Nat! on 11.05.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCDeps+MulleObjCContainerFoundation.h"


@implementation MulleObjCDeps( MulleObjCContainerFoundation)

+ (struct _mulle_objc_dependency *) dependencies
{
   static struct _mulle_objc_dependency   dependencies[] =
   {

#include "objc-deps.inc"

      { MULLE_OBJC_NO_CLASSID, MULLE_OBJC_NO_CATEGORYID }
   };

   return( dependencies);
}

@end

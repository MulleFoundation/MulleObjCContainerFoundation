//
//  MulleObjCLoader+Foundation.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 11.05.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCLoader+MulleObjCStandardFoundation.h"


@implementation MulleObjCLoader( MulleObjCStandardFoundation)

+ (struct _mulle_objc_dependency *) dependencies
{
   static struct _mulle_objc_dependency   dependencies[] =
   {

#include "dependencies.inc"

      { MULLE_OBJC_NO_CLASSID, MULLE_OBJC_NO_CATEGORYID }
   };

   return( dependencies);
}

@end

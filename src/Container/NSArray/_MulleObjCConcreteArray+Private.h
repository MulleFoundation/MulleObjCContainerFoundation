//
//  _MulleObjCConcreteArray+Private.h
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteArray.h"

static inline id   *_MulleObjCConcreteArrayGetObjects( _MulleObjCConcreteArray *_self)
{
   struct { @defs( _MulleObjCConcreteArray); }  *self = (void *) _self;
   return( (id *) (&self->_count + 1));
}

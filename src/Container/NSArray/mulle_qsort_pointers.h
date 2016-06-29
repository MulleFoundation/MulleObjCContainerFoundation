//
//  mulle_qsort_pointers.h
//  MulleObjCFoundation
//
//  Created by Nat! on 29.06.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifndef mulle_qsort_pointers_h__
#define mulle_qsort_pointers_h__

#include <stddef.h>

//
// needed, because qsort_t is not portable
// since it's incompatible anyway, mulle_qsort_pointers is even less compatible
//
// a) different callback parameters (no indirection, userinfo in the back)
// b) no element size
// c) different order of cmp and userinfo (with regards to BSD)
//
void   mulle_qsort_pointers( void **pointers,
                             size_t n,
                             int (*cmp)( void *a, void *b, void *userinfo),
                             void *userinfo);

#endif

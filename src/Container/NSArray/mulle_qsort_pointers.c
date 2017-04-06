//
//  mulle_qsort_pointers.c
//  MulleObjCFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#include <stddef.h>

typedef void *  mulle_qsorttype_t;

void   mulle_qsort_pointers( mulle_qsorttype_t *v,
                             size_t n,
                             int (*cmp)( mulle_qsorttype_t a, mulle_qsorttype_t b, void *userinfo),
                             void *userinfo);


/*
 ** quicksort.c -- quicksort integer array
 **
 ** public domain by Raymond Gardner     12/91
 */


static void swap( mulle_qsorttype_t *a, mulle_qsorttype_t *b)
{
   register mulle_qsorttype_t   t;

   t  = *a;
   *a = *b;
   *b = t;
}


static inline int  is_descending( int result)
{
   return( result > 0);
}


static inline int  is_ascending( int result)
{
   return( result < 0);
}


//static inline int  is_same( int result)
//{
//   return( result == 0);
//}


void   mulle_qsort_pointers( mulle_qsorttype_t *v,
                             size_t n,
                             int (*cmp)( mulle_qsorttype_t a, mulle_qsorttype_t b, void *userinfo),
                             void *userinfo)
{
   size_t   i, j, ln, rn;

   while( n > 1)
   {
      swap( &v[ 0], &v[ n / 2]);

      i = 0;
      j = n;

      for(;;)
      {
         do
            --j;
         while( is_descending( (*cmp)( v[ j], v[ 0], userinfo)));

         do
            ++i;
         while( i < j && is_ascending( (*cmp)( v[ i], v[ 0], userinfo)));

         if( i >= j)
            break;

         swap( &v[ i], &v[ j]);
      }
      swap( &v[ j], &v[ 0]);

      ln = j;
      rn = n - ++j;

      if( ln < rn)
      {
         mulle_qsort_pointers( v, ln, cmp, userinfo);
         v += j;
         n = rn;
      }
      else
      {
         mulle_qsort_pointers( &v[ j], rn, cmp, userinfo);
         n = ln;
      }
   }
}

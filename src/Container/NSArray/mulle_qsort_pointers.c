//
//  mulle_qsort_id.c
//  MulleObjCFoundation
//
//  Created by Nat! on 29.06.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
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


static inline int  isDescending( int result)
{
   return( result > 0);
}


static inline int  isAscending( int result)
{
   return( result < 0);
}


static inline int  isSame( int result)
{
   return( result == 0);
}


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
         while( isDescending( (*cmp)( v[ j], v[ 0], userinfo)));

         do
            ++i;
         while( i < j && isAscending( (*cmp)( v[ i], v[ 0], userinfo)));

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

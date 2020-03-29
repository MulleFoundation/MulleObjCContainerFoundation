#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

#include <unistd.h>


int   main( int argc, char *argv[])
{
#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      _exit( 1);
#endif

   return( [[NSArray array] count]);
}

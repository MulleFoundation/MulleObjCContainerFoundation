#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

#include <unistd.h>

@interface Foo : NSObject
{
   char   _name[ 32];
}

- (id) initWithMaxRand:(NSUInteger) n;

@end


@implementation Foo

- (id) initWithMaxRand:(NSUInteger) n
{
   sprintf( _name, "%lu", rand() % (n - n / 10));
   return( self);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other isKindOfClass:[Foo class]])
      return( NO);
   return( ! strcmp( self->_name,  ((Foo *) other)->_name));
}


- (NSUInteger) hash
{
   return( mulle_hash( self->_name, strlen( self->_name)));
}

@end




static NSMutableArray  *mutable_array_of_foos( NSUInteger n)
{
   NSMutableArray   *array;
   Foo              *foo;

   array = [NSMutableArray array];
   while( n)
   {
      foo = [[[Foo alloc] initWithMaxRand:n] autorelease]; // 10 % duplicates
      [array addObject:foo];
      --n;
   }
   return( array);
}


int   main( int argc, char *argv[])
{
   NSMutableArray   *a;
   NSMutableArray   *b;
   NSUInteger       i, j;
#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      _exit( 1);
#endif

   for( i = 0; i < 2048; i = ! i ? 1 : i * 2)
   {
      @autoreleasepool
      {
         a = mutable_array_of_foos( i);
         fprintf( stderr, "other: %ld\n", i);

         for( j = 0; j < 2048; j = ! j ? 1 : j * 2)
         {
            fprintf( stderr, "\tself: %ld\n", j);
            @autoreleasepool
            {
               b = mutable_array_of_foos( j);
               [b removeObjectsInArray:a];
            }
         }
      }
   }

   return( 0);
}

#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

#include <unistd.h>

@interface Foo : NSObject <NSObject, MulleObjCImmutable, MulleObjCImmutableCopying>
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
   return( mulle_data_hash( mulle_data_make( self->_name, strlen( self->_name))));
}

- (id) immutableCopy
{
   return( [self retain]);
}

@end


static NSMutableDictionary  *mutable_dictionary_of_foos( NSUInteger n)
{
   NSMutableDictionary   *dictionary;
   Foo                   *foo;
   Foo                   *bar;

   dictionary = [NSMutableDictionary dictionary];
   while( n)
   {
      foo = [[[Foo alloc] initWithMaxRand:n] autorelease]; // 10 % duplicates
      bar = [[[Foo alloc] initWithMaxRand:n] autorelease]; // 10 % duplicates
      [dictionary setObject:foo
                     forKey:bar];
      --n;
   }
   return( dictionary);
}


// just looking for a crash here
int   main( int argc, char *argv[])
{
   NSMutableDictionary   *a;
   NSMutableDictionary   *b;
   NSUInteger            i, j;

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
         a = mutable_dictionary_of_foos( i);
         fprintf( stderr, "other: %ld\n", [a count]);

         for( j = 0; j < 2048; j = ! j ? 1 : j * 2)
         {
            @autoreleasepool
            {
               b = mutable_dictionary_of_foos( j);
               fprintf( stderr, "\tself: %ld\n", [b count]);
               [b removeObjectsForKeys:[a allKeys]];
            }
         }
      }
   }

   return( 0);
}

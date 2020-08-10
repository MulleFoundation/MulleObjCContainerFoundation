#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

#include <unistd.h>

@interface Foo : NSObject
{
   char   _name[ 32];
}

@end


@implementation Foo

- (id) initWithMaxRand:(NSUInteger) n
{
   static unsigned long   i;

   sprintf( _name, "%lu", ++i);
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
   NSArray          *c;

#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      _exit( 1);
#endif

   a = mutable_array_of_foos( 1000);
   b = [[[NSMutableArray alloc] mulleInitWithContainer:a] autorelease];

   if( ! [a isEqual:b])
      return( 1);

   c = [[[NSArray alloc] mulleInitWithContainer:a] autorelease];
   if( ! [a isEqual:c])
      return( 1);

   return( 0);
}

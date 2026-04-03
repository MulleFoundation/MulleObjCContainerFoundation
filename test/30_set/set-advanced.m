#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>
#include <string.h>
#include <stdlib.h>

@interface Str : NSObject <NSObject, MulleObjCImmutable, MulleObjCImmutableCopying>
{
   char   _name[64];
}
+ (instancetype) str:(const char *) s;
- (const char *) UTF8String;
@end

@implementation Str

+ (instancetype) str:(const char *) s
{
   Str *o = [[[Str alloc] init] autorelease];
   strncpy( o->_name, s, sizeof( o->_name) - 1);
   return( o);
}

- (const char *) UTF8String
{
   return( _name);
}

- (BOOL) isEqual:(id) other
{
   if( ! [other isKindOfClass:[Str class]])
      return( NO);
   return( ! strcmp( _name, ((Str *) other)->_name));
}

- (NSUInteger) hash
{
   return( mulle_data_hash( mulle_data_make( _name, strlen( _name))));
}

- (id) immutableCopy
{
   return( [self retain]);
}

@end


int   main( void)
{
   @autoreleasepool
   {
      NSSet  *s;

      // setWithObject: (single)
      s = [NSSet setWithObject:[Str str:"solo"]];
      mulle_printf( "setWithObject count: %lu\n", (unsigned long)[s count]);
      mulle_printf( "setWithObject contains: %s\n",
         [s containsObject:[Str str:"solo"]] ? "yes" : "no");

      // initWithObjects:count:
      id initObjs[3] = { [Str str:"x"], [Str str:"y"], [Str str:"z"] };
      s = [[[NSSet alloc] initWithObjects:initObjs count:3] autorelease];
      mulle_printf( "initWithObjects:count: %lu\n", (unsigned long)[s count]);
      mulle_printf( "initWithObjects:count: has y: %s\n",
         [s containsObject:[Str str:"y"]] ? "yes" : "no");

      // initWithSet: (copy constructor)
      NSSet *src = [NSSet setWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      s = [[[NSSet alloc] initWithSet:src] autorelease];
      mulle_printf( "initWithSet count: %lu\n", (unsigned long)[s count]);
      mulle_printf( "initWithSet has a: %s\n", [s containsObject:[Str str:"a"]] ? "yes" : "no");

      // setWithSet:
      NSSet *copy = [NSSet setWithSet:src];
      mulle_printf( "setWithSet count: %lu\n", (unsigned long)[copy count]);
      mulle_printf( "setWithSet equal: %s\n", [copy isEqualToSet:src] ? "yes" : "no");

      // hash
      mulle_printf( "hash nonzero: %s\n", [src hash] != 0 ? "yes" : "no");
      mulle_printf( "empty hash: %lu\n", (unsigned long)[[NSSet set] hash]);

      // isEqual: non-set
      mulle_printf( "isEqual non-set: %s\n", [src isEqual:[Str str:"notset"]] ? "yes" : "no");
      mulle_printf( "isEqual nil: %s\n", [src isEqual:nil] ? "yes" : "no");
      mulle_printf( "isEqual same: %s\n", [src isEqual:copy] ? "yes" : "no");

      // fast enumeration on set (covers countByEnumeratingWithState:)
      NSUInteger count = 0;
      id obj;
      for( obj in src)
         count++;
      mulle_printf( "fast enum count: %lu\n", (unsigned long)count);

      // empty set edge cases
      NSSet *empty = [NSSet set];
      mulle_printf( "empty isSubset of src: %s\n",
         [empty isSubsetOfSet:src] ? "yes" : "no");
      mulle_printf( "empty count: %lu\n", (unsigned long)[empty count]);
   }
   return( 0);
}

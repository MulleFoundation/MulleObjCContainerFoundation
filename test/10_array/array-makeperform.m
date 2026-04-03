#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>
#include <string.h>

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
      NSArray  *a = [NSArray arrayWithObjects:[Str str:"one"], [Str str:"two"], [Str str:"three"], nil];

      // makeObjectsPerformSelector:
      [a makeObjectsPerformSelector:@selector(hash)];
      mulle_printf( "makeObjectsPerformSelector: ok\n");

      // NSMutableArray makeObjectsPerformSelector:
      NSMutableArray *ma = [NSMutableArray arrayWithObjects:
         [Str str:"alpha"],
         [Str str:"beta"], nil];
      [ma makeObjectsPerformSelector:@selector(hash)];
      mulle_printf( "mutable makeObjectsPerformSelector: ok\n");

      // makeObjectsPerformSelector:withObject:
      [ma makeObjectsPerformSelector:@selector(isEqual:) withObject:[Str str:"alpha"]];
      mulle_printf( "makeObjectsPerformSelector:withObject: ok\n");

      // NSSet makeObjectsPerformSelector:
      NSSet *s = [NSSet setWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      [s makeObjectsPerformSelector:@selector(hash)];
      mulle_printf( "set makeObjectsPerformSelector: ok\n");

      // anyObject via MulleObjCContainer
      id any = [s anyObject];
      mulle_printf( "anyObject non-nil: %s\n", any != nil ? "yes" : "no");
      mulle_printf( "done\n");
   }
   return( 0);
}

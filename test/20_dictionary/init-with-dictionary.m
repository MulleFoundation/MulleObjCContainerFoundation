#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

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
      // initWithDictionary: from empty NSDictionary
      NSDictionary *empty = [NSDictionary dictionary];
      NSDictionary *d1 = [[[NSDictionary alloc] initWithDictionary:empty] autorelease];
      mulle_printf( "from empty immutable: %lu\n", (unsigned long)[d1 count]);

      // initWithDictionary: from non-empty NSDictionary
      NSDictionary *src = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"v1"], [Str str:"k1"],
         [Str str:"v2"], [Str str:"k2"],
         [Str str:"v3"], [Str str:"k3"],
         nil];
      NSDictionary *d2 = [[[NSDictionary alloc] initWithDictionary:src] autorelease];
      mulle_printf( "from immutable count: %lu\n", (unsigned long)[d2 count]);
      mulle_printf( "from immutable k1: %s\n", [[d2 objectForKey:[Str str:"k1"]] UTF8String]);
      mulle_printf( "from immutable k3: %s\n", [[d2 objectForKey:[Str str:"k3"]] UTF8String]);
      mulle_printf( "from immutable equal: %s\n", [d2 isEqualToDictionary:src] ? "yes" : "no");

      // initWithDictionary: from empty NSMutableDictionary
      NSMutableDictionary *emptyMut = [NSMutableDictionary dictionary];
      NSDictionary *d3 = [[[NSDictionary alloc] initWithDictionary:emptyMut] autorelease];
      mulle_printf( "from empty mutable: %lu\n", (unsigned long)[d3 count]);

      // initWithDictionary: from non-empty NSMutableDictionary
      NSMutableDictionary *msrc = [NSMutableDictionary dictionary];
      [msrc setObject:[Str str:"a"] forKey:[Str str:"x"]];
      [msrc setObject:[Str str:"b"] forKey:[Str str:"y"]];
      NSDictionary *d4 = [[[NSDictionary alloc] initWithDictionary:msrc] autorelease];
      mulle_printf( "from mutable count: %lu\n", (unsigned long)[d4 count]);
      mulle_printf( "from mutable x: %s\n", [[d4 objectForKey:[Str str:"x"]] UTF8String]);
      mulle_printf( "from mutable equal: %s\n", [d4 isEqualToDictionary:msrc] ? "yes" : "no");

      // NSMutableDictionary initWithDictionary: from NSDictionary
      NSMutableDictionary *md1 = [[[NSMutableDictionary alloc] initWithDictionary:src] autorelease];
      mulle_printf( "mut from immutable count: %lu\n", (unsigned long)[md1 count]);
      mulle_printf( "mut from immutable k2: %s\n", [[md1 objectForKey:[Str str:"k2"]] UTF8String]);
      mulle_printf( "mut from immutable equal: %s\n", [md1 isEqualToDictionary:src] ? "yes" : "no");

      // NSMutableDictionary initWithDictionary: from NSMutableDictionary
      NSMutableDictionary *md2 = [[[NSMutableDictionary alloc] initWithDictionary:msrc] autorelease];
      mulle_printf( "mut from mutable count: %lu\n", (unsigned long)[md2 count]);
      mulle_printf( "mut from mutable y: %s\n", [[md2 objectForKey:[Str str:"y"]] UTF8String]);

      // NSMutableDictionary initWithDictionary: from empty
      NSMutableDictionary *md3 = [[[NSMutableDictionary alloc] initWithDictionary:empty] autorelease];
      mulle_printf( "mut from empty: %lu\n", (unsigned long)[md3 count]);
      [md3 setObject:[Str str:"added"] forKey:[Str str:"new"]];
      mulle_printf( "mut from empty after add: %lu\n", (unsigned long)[md3 count]);

      // large dictionary
      NSMutableDictionary *large = [NSMutableDictionary dictionary];
      NSUInteger i;
      for( i = 0; i < 100; i++)
      {
         char kbuf[16], vbuf[16];
         sprintf( kbuf, "k%lu", (unsigned long) i);
         sprintf( vbuf, "v%lu", (unsigned long) i);
         [large setObject:[Str str:vbuf] forKey:[Str str:kbuf]];
      }
      NSDictionary *d5 = [[[NSDictionary alloc] initWithDictionary:large] autorelease];
      mulle_printf( "from large count: %lu\n", (unsigned long)[d5 count]);
      mulle_printf( "from large k50: %s\n", [[d5 objectForKey:[Str str:"k50"]] UTF8String]);

      NSMutableDictionary *md4 = [[[NSMutableDictionary alloc] initWithDictionary:large] autorelease];
      mulle_printf( "mut from large count: %lu\n", (unsigned long)[md4 count]);
      mulle_printf( "mut from large k99: %s\n", [[md4 objectForKey:[Str str:"k99"]] UTF8String]);

      // single entry dictionary
      NSDictionary *single = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"only"], [Str str:"one"], nil];
      NSDictionary *d6 = [[[NSDictionary alloc] initWithDictionary:single] autorelease];
      mulle_printf( "from single count: %lu\n", (unsigned long)[d6 count]);
      mulle_printf( "from single one: %s\n", [[d6 objectForKey:[Str str:"one"]] UTF8String]);
   }
   return( 0);
}

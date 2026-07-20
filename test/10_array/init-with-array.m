#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

@interface Str : NSObject <NSObject, MulleObjCImmutable, MulleObjCImmutableCopying>
{
   char   _name[64];
}
+ (instancetype) str:(const char *) s;
- (const char *) UTF8String;
- (NSComparisonResult) compare:(Str *) other;
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

- (NSComparisonResult) compare:(Str *) other
{
   int r = strcmp( _name, other->_name);
   return( r < 0 ? NSOrderedAscending : r > 0 ? NSOrderedDescending : NSOrderedSame);
}

@end


int   main( void)
{
   @autoreleasepool
   {
      // initWithArray: from empty NSArray
      NSArray *empty = [NSArray array];
      NSArray *a1 = [[[NSArray alloc] initWithArray:empty] autorelease];
      mulle_printf( "from empty immutable: %lu\n", (unsigned long)[a1 count]);

      // initWithArray: from non-empty NSArray
      NSArray *src = [NSArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      NSArray *a2 = [[[NSArray alloc] initWithArray:src] autorelease];
      mulle_printf( "from immutable count: %lu\n", (unsigned long)[a2 count]);
      mulle_printf( "from immutable [0]: %s\n", [[a2 objectAtIndex:0] UTF8String]);
      mulle_printf( "from immutable [2]: %s\n", [[a2 objectAtIndex:2] UTF8String]);
      mulle_printf( "from immutable equal: %s\n", [a2 isEqualToArray:src] ? "yes" : "no");

      // initWithArray: from empty NSMutableArray
      NSMutableArray *emptyMut = [NSMutableArray array];
      NSArray *a3 = [[[NSArray alloc] initWithArray:emptyMut] autorelease];
      mulle_printf( "from empty mutable: %lu\n", (unsigned long)[a3 count]);

      // initWithArray: from non-empty NSMutableArray
      NSMutableArray *msrc = [NSMutableArray array];
      [msrc addObject:[Str str:"x"]];
      [msrc addObject:[Str str:"y"]];
      NSArray *a4 = [[[NSArray alloc] initWithArray:msrc] autorelease];
      mulle_printf( "from mutable count: %lu\n", (unsigned long)[a4 count]);
      mulle_printf( "from mutable [0]: %s\n", [[a4 objectAtIndex:0] UTF8String]);
      mulle_printf( "from mutable equal: %s\n", [a4 isEqualToArray:msrc] ? "yes" : "no");

      // NSMutableArray initWithArray: from NSArray
      NSMutableArray *ma1 = [[[NSMutableArray alloc] initWithArray:src] autorelease];
      mulle_printf( "mut from immutable count: %lu\n", (unsigned long)[ma1 count]);
      mulle_printf( "mut from immutable [1]: %s\n", [[ma1 objectAtIndex:1] UTF8String]);
      mulle_printf( "mut from immutable equal: %s\n", [ma1 isEqualToArray:src] ? "yes" : "no");

      // NSMutableArray initWithArray: from NSMutableArray
      NSMutableArray *ma2 = [[[NSMutableArray alloc] initWithArray:msrc] autorelease];
      mulle_printf( "mut from mutable count: %lu\n", (unsigned long)[ma2 count]);
      mulle_printf( "mut from mutable [1]: %s\n", [[ma2 objectAtIndex:1] UTF8String]);

      // NSMutableArray initWithArray: from empty, then add
      NSMutableArray *ma3 = [[[NSMutableArray alloc] initWithArray:empty] autorelease];
      mulle_printf( "mut from empty: %lu\n", (unsigned long)[ma3 count]);
      [ma3 addObject:[Str str:"added"]];
      mulle_printf( "mut from empty after add: %lu\n", (unsigned long)[ma3 count]);

      // large array
      NSMutableArray *large = [NSMutableArray array];
      NSUInteger i;
      for( i = 0; i < 100; i++)
      {
         char buf[16];
         sprintf( buf, "e%lu", (unsigned long) i);
         [large addObject:[Str str:buf]];
      }
      NSArray *a5 = [[[NSArray alloc] initWithArray:large] autorelease];
      mulle_printf( "from large count: %lu\n", (unsigned long)[a5 count]);
      mulle_printf( "from large [50]: %s\n", [[a5 objectAtIndex:50] UTF8String]);

      NSMutableArray *ma4 = [[[NSMutableArray alloc] initWithArray:large] autorelease];
      mulle_printf( "mut from large count: %lu\n", (unsigned long)[ma4 count]);
      mulle_printf( "mut from large [99]: %s\n", [[ma4 objectAtIndex:99] UTF8String]);

      // single element
      NSArray *single = [NSArray arrayWithObjects:[Str str:"only"], nil];
      NSArray *a6 = [[[NSArray alloc] initWithArray:single] autorelease];
      mulle_printf( "from single count: %lu\n", (unsigned long)[a6 count]);
      mulle_printf( "from single [0]: %s\n", [[a6 objectAtIndex:0] UTF8String]);
   }
   return( 0);
}

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
      // initWithSet: from empty NSSet
      NSSet *empty = [NSSet set];
      NSSet *s1 = [[[NSSet alloc] initWithSet:empty] autorelease];
      mulle_printf( "from empty immutable: %lu\n", (unsigned long)[s1 count]);

      // initWithSet: from non-empty NSSet
      NSSet *src = [NSSet setWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      NSSet *s2 = [[[NSSet alloc] initWithSet:src] autorelease];
      mulle_printf( "from immutable count: %lu\n", (unsigned long)[s2 count]);
      mulle_printf( "from immutable has a: %s\n", [s2 containsObject:[Str str:"a"]] ? "yes" : "no");
      mulle_printf( "from immutable has c: %s\n", [s2 containsObject:[Str str:"c"]] ? "yes" : "no");
      mulle_printf( "from immutable equal: %s\n", [s2 isEqualToSet:src] ? "yes" : "no");

      // initWithSet: from empty NSMutableSet
      NSMutableSet *emptyMut = [NSMutableSet set];
      NSSet *s3 = [[[NSSet alloc] initWithSet:emptyMut] autorelease];
      mulle_printf( "from empty mutable: %lu\n", (unsigned long)[s3 count]);

      // initWithSet: from non-empty NSMutableSet
      NSMutableSet *msrc = [NSMutableSet set];
      [msrc addObject:[Str str:"x"]];
      [msrc addObject:[Str str:"y"]];
      NSSet *s4 = [[[NSSet alloc] initWithSet:msrc] autorelease];
      mulle_printf( "from mutable count: %lu\n", (unsigned long)[s4 count]);
      mulle_printf( "from mutable has x: %s\n", [s4 containsObject:[Str str:"x"]] ? "yes" : "no");
      mulle_printf( "from mutable equal: %s\n", [s4 isEqualToSet:msrc] ? "yes" : "no");

      // NSMutableSet initWithSet: from NSSet
      NSMutableSet *ms1 = [[[NSMutableSet alloc] initWithSet:src] autorelease];
      mulle_printf( "mut from immutable count: %lu\n", (unsigned long)[ms1 count]);
      mulle_printf( "mut from immutable has b: %s\n", [ms1 containsObject:[Str str:"b"]] ? "yes" : "no");
      mulle_printf( "mut from immutable equal: %s\n", [ms1 isEqualToSet:src] ? "yes" : "no");

      // NSMutableSet initWithSet: from NSMutableSet
      NSMutableSet *ms2 = [[[NSMutableSet alloc] initWithSet:msrc] autorelease];
      mulle_printf( "mut from mutable count: %lu\n", (unsigned long)[ms2 count]);
      mulle_printf( "mut from mutable has y: %s\n", [ms2 containsObject:[Str str:"y"]] ? "yes" : "no");

      // NSMutableSet initWithSet: from empty, then add
      NSMutableSet *ms3 = [[[NSMutableSet alloc] initWithSet:empty] autorelease];
      mulle_printf( "mut from empty: %lu\n", (unsigned long)[ms3 count]);
      [ms3 addObject:[Str str:"added"]];
      mulle_printf( "mut from empty after add: %lu\n", (unsigned long)[ms3 count]);

      // large set
      NSMutableSet *large = [NSMutableSet set];
      NSUInteger i;
      for( i = 0; i < 100; i++)
      {
         char buf[16];
         sprintf( buf, "e%lu", (unsigned long) i);
         [large addObject:[Str str:buf]];
      }
      NSSet *s5 = [[[NSSet alloc] initWithSet:large] autorelease];
      mulle_printf( "from large count: %lu\n", (unsigned long)[s5 count]);
      mulle_printf( "from large has e50: %s\n", [s5 containsObject:[Str str:"e50"]] ? "yes" : "no");

      NSMutableSet *ms4 = [[[NSMutableSet alloc] initWithSet:large] autorelease];
      mulle_printf( "mut from large count: %lu\n", (unsigned long)[ms4 count]);
      mulle_printf( "mut from large has e99: %s\n", [ms4 containsObject:[Str str:"e99"]] ? "yes" : "no");

      // single element
      NSSet *single = [NSSet setWithObjects:[Str str:"only"], nil];
      NSSet *s6 = [[[NSSet alloc] initWithSet:single] autorelease];
      mulle_printf( "from single count: %lu\n", (unsigned long)[s6 count]);
      mulle_printf( "from single has only: %s\n", [s6 containsObject:[Str str:"only"]] ? "yes" : "no");
   }
   return( 0);
}

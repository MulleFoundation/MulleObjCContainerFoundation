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
      NSMutableSet *ms;

      ms = [NSMutableSet set];
      mulle_printf( "empty count: %lu\n", (unsigned long)[ms count]);

      // addObject:
      [ms addObject:[Str str:"one"]];
      [ms addObject:[Str str:"two"]];
      [ms addObject:[Str str:"three"]];
      mulle_printf( "after 3 adds: %lu\n", (unsigned long)[ms count]);

      // addObject: duplicate (no change)
      [ms addObject:[Str str:"one"]];
      mulle_printf( "after duplicate add: %lu\n", (unsigned long)[ms count]);

      // containsObject:
      mulle_printf( "contains one: %s\n", [ms containsObject:[Str str:"one"]] ? "yes" : "no");

      // removeObject:
      [ms removeObject:[Str str:"two"]];
      mulle_printf( "after remove two: %lu\n", (unsigned long)[ms count]);
      mulle_printf( "two gone: %s\n", [ms containsObject:[Str str:"two"]] ? "yes" : "no");

      // addObjectsFromArray:
      [ms addObjectsFromArray:[NSArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil]];
      mulle_printf( "after addFromArray: %lu\n", (unsigned long)[ms count]);

      // unionSet:
      NSSet *other = [NSSet setWithObjects:[Str str:"x"], [Str str:"y"], nil];
      [ms unionSet:other];
      mulle_printf( "after union count: %lu\n", (unsigned long)[ms count]);
      mulle_printf( "contains x: %s\n", [ms containsObject:[Str str:"x"]] ? "yes" : "no");

      // minusSet:
      [ms minusSet:other];
      mulle_printf( "after minus count: %lu\n", (unsigned long)[ms count]);
      mulle_printf( "x gone: %s\n", [ms containsObject:[Str str:"x"]] ? "yes" : "no");

      // intersectSet:
      [ms removeAllObjects];
      [ms addObject:[Str str:"p"]];
      [ms addObject:[Str str:"q"]];
      [ms addObject:[Str str:"r"]];
      NSSet *inter = [NSSet setWithObjects:[Str str:"q"], [Str str:"r"], [Str str:"s"], nil];
      [ms intersectSet:inter];
      mulle_printf( "after intersect count: %lu\n", (unsigned long)[ms count]);
      mulle_printf( "q present: %s\n", [ms containsObject:[Str str:"q"]] ? "yes" : "no");
      mulle_printf( "p gone: %s\n", [ms containsObject:[Str str:"p"]] ? "yes" : "no");

      // removeAllObjects
      [ms removeAllObjects];
      mulle_printf( "after removeAll: %lu\n", (unsigned long)[ms count]);

      // setWithSet: init
      NSMutableSet *ms2 = [NSMutableSet setWithSet:[NSSet setWithObjects:[Str str:"1"], [Str str:"2"], nil]];
      mulle_printf( "setWithSet count: %lu\n", (unsigned long)[ms2 count]);

      // verify contents still accessible
      [ms addObject:[Str str:"foo"]];
      [ms addObject:[Str str:"bar"]];
      mulle_printf( "after re-add count: %lu\n", (unsigned long)[ms count]);
      mulle_printf( "foo present: %s\n", [ms containsObject:[Str str:"foo"]] ? "yes" : "no");
   }
   return( 0);
}

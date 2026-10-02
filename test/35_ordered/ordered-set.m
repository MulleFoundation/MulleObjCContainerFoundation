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
   Str *o = [Str instance];
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


static void   print_order( const char *label, NSOrderedSet *set)
{
   Str    *object;
   int    first;

   mulle_printf( "%s:", label);
   first = 1;
   for( object in set)
   {
      mulle_printf( "%s%s", first ? "" : ",", [object UTF8String]);
      first = 0;
   }
   mulle_printf( "\n");
}


int   main( void)
{
   @autoreleasepool
   {
      NSOrderedSet         *os;
      NSMutableOrderedSet  *ms;
      NSArray              *array;
      NSSet                *set;
      NSUInteger           index;

      // creation dedupes but keeps first occurrence's position
      os = [NSOrderedSet orderedSetWithObjects:[Str str:"alpha"],
                                               [Str str:"beta"],
                                               [Str str:"alpha"],
                                               [Str str:"gamma"],
                                               nil];
      print_order( "immutable", os);
      mulle_printf( "count: %lu\n", (unsigned long) [os count]);
      mulle_printf( "contains beta: %s\n", [os containsObject:[Str str:"beta"]] ? "yes" : "no");
      mulle_printf( "contains delta: %s\n", [os containsObject:[Str str:"delta"]] ? "yes" : "no");
      mulle_printf( "member beta: %s\n", [os member:[Str str:"beta"]] != nil ? "yes" : "no");
      index = [os indexOfObject:[Str str:"gamma"]];
      mulle_printf( "index of gamma: %lu\n", (unsigned long) index);
      mulle_printf( "index of delta: %s\n", [os indexOfObject:[Str str:"delta"]] == NSNotFound ? "notfound" : "found");
      mulle_printf( "first: %s\n", [[os firstObject] UTF8String]);
      mulle_printf( "last: %s\n", [[os lastObject] UTF8String]);
      mulle_printf( "objectAtIndex 1: %s\n", [[os objectAtIndex:1] UTF8String]);

      array = [os array];
      mulle_printf( "array count: %lu\n", (unsigned long) [array count]);
      set   = [os set];
      mulle_printf( "set count: %lu\n", (unsigned long) [set count]);

      // immutable equality is order sensitive
      mulle_printf( "equal same: %s\n",
                     [os isEqualToOrderedSet:[NSOrderedSet orderedSetWithArray:array]] ? "yes" : "no");
      mulle_printf( "equal reversed: %s\n",
                     [os isEqualToOrderedSet:[NSOrderedSet orderedSetWithObjects:[Str str:"gamma"],
                                                                               [Str str:"beta"],
                                                                               [Str str:"alpha"],
                                                                               nil]] ? "yes" : "no");

      // mutable
      ms = [NSMutableOrderedSet orderedSetWithCapacity:4];
      [ms addObject:[Str str:"one"]];
      [ms addObject:[Str str:"two"]];
      [ms addObject:[Str str:"three"]];
      print_order( "mutable", ms);

      // duplicate is a no-op
      [ms addObject:[Str str:"one"]];
      print_order( "after dup add", ms);

      [ms insertObject:[Str str:"half"]
               atIndex:1];
      print_order( "after insert half@1", ms);

      [ms replaceObjectAtIndex:0
                  withObject:[Str str:"uno"]];
      print_order( "after replace one->uno", ms);

      [ms removeObject:[Str str:"three"]];
      print_order( "after remove three", ms);

      [ms removeObjectAtIndex:0];
      print_order( "after remove at 0", ms);

      [ms addObjectsFromArray:[NSArray arrayWithObjects:[Str str:"x"],
                                                         [Str str:"y"],
                                                         [Str str:"half"],
                                                         nil]];
      print_order( "after addObjectsFromArray", ms);
      mulle_printf( "mutable count: %lu\n", (unsigned long) [ms count]);

      // mutable -> immutable
      os = [NSOrderedSet orderedSetWithOrderedSet:ms];
      print_order( "immutable from mutable", os);
      mulle_printf( "immutable isEqual: %s\n", [os isEqual:ms] ? "yes" : "no");

      // removing
      os = [os mulleOrderedSetByRemovingObject:[Str str:"y"]];
      print_order( "after remove y", os);

      [ms removeAllObjects];
      mulle_printf( "empty mutable count: %lu\n", (unsigned long) [ms count]);
      mulle_printf( "empty first: %s\n", [ms firstObject] == nil ? "nil" : "not-nil");
      mulle_printf( "empty contains: %s\n", [ms containsObject:[Str str:"x"]] ? "yes" : "no");
   }
   return( 0);
}

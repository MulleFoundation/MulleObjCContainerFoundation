#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>
#include <string.h>


//
// Deliberately NOT MulleObjCImmutable, so instances are ordinary autoreleased
// objects that really get deallocated. That makes the churn at the bottom a
// meaningful leak check.
//
@interface Str : NSObject
{
   char   _name[64];
}
+ (instancetype) str:(const char *) s;
- (char *) UTF8String;
@end


@implementation Str

+ (instancetype) str:(const char *) s
{
   Str *o = [Str instance];
   strncpy( o->_name, s, sizeof( o->_name) - 1);
   return( o);
}

- (char *) UTF8String
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

@end


static void   print_order( const char *label, NSMutableOrderedSet *set)
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
      NSMutableOrderedSet   *ms;
      Str                   *canonical;
      id                    objects[4];
      NSUInteger            i;

      //
      // valid boundary: index == count appends
      //
      ms = [NSMutableOrderedSet orderedSet];
      [ms addObject:[Str str:"first"]];
      [ms addObject:[Str str:"second"]];
      [ms insertObject:[Str str:"third"]
               atIndex:2];
      print_order( "boundary append", ms);

      // valid full range
      [ms getObjects:objects
                range:NSRangeMake( 0, 3)];
      mulle_printf( "getObjects full: %s,%s,%s\n",
                     [(Str *) objects[0] UTF8String],
                     [(Str *) objects[1] UTF8String],
                     [(Str *) objects[2] UTF8String]);

      //
      // duplicate insert / replace behavior
      //
      ms = [NSMutableOrderedSet orderedSetWithCapacity:4];
      canonical = [Str str:"alpha"];
      [ms addObject:canonical];
      [ms addObject:[Str str:"beta"]];
      [ms addObject:[Str str:"gamma"]];
      print_order( "base", ms);

      // adding an equal object is a no-op
      [ms addObject:[Str str:"alpha"]];
      print_order( "after dup addObject", ms);

      // the canonical (first inserted) object is kept
      mulle_printf( "member is canonical: %s\n",
                     [ms member:[Str str:"alpha"]] == canonical ? "yes" : "no");

      // inserting an existing object anywhere is a no-op, no reordering
      [ms insertObject:[Str str:"beta"]
               atIndex:0];
      print_order( "after insert existing beta@0", ms);

      // replacing with an object that is already present is a no-op
      [ms replaceObjectAtIndex:0
                  withObject:[Str str:"gamma"]];
      print_order( "after replace alpha->gamma", ms);

      // replacing with an equal object of the current value is a no-op
      [ms replaceObjectAtIndex:0
                  withObject:[Str str:"alpha"]];
      print_order( "after replace alpha->alpha", ms);

      // replacing with a genuinely new object replaces in place
      [ms replaceObjectAtIndex:1
                  withObject:[Str str:"delta"]];
      print_order( "after replace beta->delta", ms);
      mulle_printf( "contains beta: %s\n", [ms containsObject:[Str str:"beta"]] ? "yes" : "no");
      mulle_printf( "contains delta: %s\n", [ms containsObject:[Str str:"delta"]] ? "yes" : "no");
      mulle_printf( "count: %lu\n", (unsigned long) [ms count]);

      // plural insertion, duplicate element must be skipped
      objects[0] = [Str str:"x"];
      objects[1] = [Str str:"alpha"];
      [ms insertObjects:objects
                  count:2
                atIndex:0];
      print_order( "after insertObjects", ms);

      //
      // churn to exercise dealloc of the map + pointerarray and the objects
      //
      for( i = 0; i < 100; i++)
      {
         @autoreleasepool
         {
            NSMutableOrderedSet   *tmp;

            tmp = [NSMutableOrderedSet orderedSetWithCapacity:16];
            [tmp addObject:[Str str:"x"]];
            [tmp addObject:[Str str:"y"]];
            [tmp insertObject:[Str str:"m"]
                      atIndex:1];
            [tmp replaceObjectAtIndex:0
                        withObject:[Str str:"z"]];
            [tmp removeObject:[Str str:"y"]];
            [tmp removeObjectAtIndex:0];

            tmp = [NSMutableOrderedSet orderedSetWithOrderedSet:ms];
            [tmp removeAllObjects];
         }
      }
      mulle_printf( "churn survived: yes\n");
   }
   return( 0);
}

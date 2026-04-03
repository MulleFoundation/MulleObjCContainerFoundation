#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>
#include <string.h>

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


static NSComparisonResult  reverseCompare( id a, id b, void *ctx)
{
   return( [(Str *) b compare:(Str *) a]);
}


int   main( void)
{
   @autoreleasepool
   {
      NSMutableArray  *ma;

      // mulleInitWithContainer: — init from any NSFastEnumeration
      NSSet *sourceSet = [NSSet setWithObjects:[Str str:"p"], [Str str:"q"], [Str str:"r"], nil];
      ma = [[[NSMutableArray alloc] mulleInitWithContainer:sourceSet] autorelease];
      mulle_printf( "mulleInitWithContainer count: %lu\n", (unsigned long)[ma count]);

      // makeObjectsPerformSelector:
      ma = [NSMutableArray arrayWithObjects:[Str str:"ten"], [Str str:"twenty"], nil];
      [ma makeObjectsPerformSelector:@selector(hash)];
      mulle_printf( "makeObjectsPerformSelector: ok\n");

      // sortUsingFunction:
      ma = [NSMutableArray arrayWithObjects:[Str str:"cherry"], [Str str:"apple"], [Str str:"banana"], nil];
      [ma sortUsingFunction:reverseCompare context:NULL];
      mulle_printf( "funcSort[0]: %s\n", [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "funcSort[2]: %s\n", [[ma objectAtIndex:2] UTF8String]);

      // mulleReverseObjects
      ma = [NSMutableArray arrayWithObjects:[Str str:"first"], [Str str:"second"], [Str str:"third"], nil];
      [ma mulleReverseObjects];
      mulle_printf( "reversed[0]: %s\n", [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "reversed[2]: %s\n", [[ma objectAtIndex:2] UTF8String]);

      // mulleArrayByRemovingObject:
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"b"], nil];
      NSArray *removed = [ma mulleArrayByRemovingObject:[Str str:"b"]];
      mulle_printf( "arrayByRemoving count: %lu\n", (unsigned long)[removed count]);
      mulle_printf( "arrayByRemoving contains b: %s\n",
         [removed containsObject:[Str str:"b"]] ? "yes" : "no");

      // removeObjectIdenticalTo:
      Str *target = [Str str:"hello"];
      ma = [NSMutableArray arrayWithObjects:[Str str:"world"], target, [Str str:"foo"], target, nil];
      [ma removeObjectIdenticalTo:target];
      mulle_printf( "removeIdentical count: %lu\n", (unsigned long)[ma count]);
      mulle_printf( "removeIdentical contains: %s\n",
         [ma containsObject:target] ? "yes" : "no");

      // getObjects:range:
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"d"], nil];
      id buf[2];
      [ma getObjects:buf range:NSMakeRange(1, 2)];
      mulle_printf( "getObjects:range:[0]: %s\n", [buf[0] UTF8String]);
      mulle_printf( "getObjects:range:[1]: %s\n", [buf[1] UTF8String]);

      // mulleMoveObjectsInRange:toIndex:
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"d"], [Str str:"e"], nil];
      [ma mulleMoveObjectsInRange:NSMakeRange(1, 2) toIndex:3];
      mulle_printf( "moveRange count: %lu\n", (unsigned long)[ma count]);
   }
   return( 0);
}

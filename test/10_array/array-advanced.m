#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>
#include <string.h>
#include <stdlib.h>

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
      NSArray  *a = [NSArray arrayWithObjects:[Str str:"apple"], [Str str:"banana"], [Str str:"cherry"], nil];
      NSArray  *b = [NSArray arrayWithObjects:[Str str:"banana"], [Str str:"cherry"], [Str str:"durian"], nil];

      // firstObjectCommonWithArray:
      id common = [a firstObjectCommonWithArray:b];
      mulle_printf( "firstCommon: %s\n", [common UTF8String]);

      NSArray *noCommon = [NSArray arrayWithObjects:[Str str:"x"], [Str str:"y"], nil];
      mulle_printf( "firstCommon none: %s\n",
         [a firstObjectCommonWithArray:noCommon] == nil ? "nil" : "not-nil");

      // indexOfObjectIdenticalTo: (pointer identity)
      Str      *obj       = [Str str:"banana"];
      Str      *different = [Str str:"banana"];  // equal but not identical
      NSArray  *c         = [NSArray arrayWithObjects:[Str str:"apple"], obj, [Str str:"cherry"], nil];
      mulle_printf( "indexOfIdentical: %lu\n",
         (unsigned long)[c indexOfObjectIdenticalTo:obj]);
      mulle_printf( "indexOfIdentical miss: %s\n",
         [c indexOfObjectIdenticalTo:[Str str:"newstring"]] == NSNotFound ? "notfound" : "found");

      // mulleContainsObjectIdenticalTo:
      mulle_printf( "containsIdentical yes: %s\n",
         [c mulleContainsObjectIdenticalTo:obj] ? "yes" : "no");
      mulle_printf( "containsIdentical no: %s\n",
         [c mulleContainsObjectIdenticalTo:different] ? "yes" : "no");

      // hash (just check nonzero)
      mulle_printf( "hash nonzero: %s\n", [a hash] != 0 ? "yes" : "no");

      // isEqual: with array and non-array
      NSArray *same = [NSArray arrayWithObjects:[Str str:"apple"], [Str str:"banana"], [Str str:"cherry"], nil];
      mulle_printf( "isEqual same: %s\n", [a isEqual:same] ? "yes" : "no");
      mulle_printf( "isEqual nil: %s\n", [a isEqual:nil] ? "yes" : "no");
      mulle_printf( "isEqual str: %s\n", [a isEqual:[Str str:"notarray"]] ? "yes" : "no");

      // arrayByAddingObject:
      NSArray *added = [a arrayByAddingObject:[Str str:"durian"]];
      mulle_printf( "arrayByAdding count: %lu\n", (unsigned long)[added count]);
      mulle_printf( "arrayByAdding last: %s\n", [[added lastObject] UTF8String]);

      // arrayByAddingObjectsFromArray:
      NSArray *extra = [NSArray arrayWithObjects:[Str str:"elderberry"], [Str str:"fig"], nil];
      NSArray *combined = [a arrayByAddingObjectsFromArray:extra];
      mulle_printf( "arrayByAddingFrom count: %lu\n", (unsigned long)[combined count]);

      // sortedArrayUsingFunction:
      NSArray *unsorted = [NSArray arrayWithObjects:[Str str:"cherry"], [Str str:"apple"], [Str str:"banana"], nil];
      NSArray *fsorted = [unsorted sortedArrayUsingFunction:reverseCompare context:NULL];
      mulle_printf( "funcSorted[0]: %s\n", [[fsorted objectAtIndex:0] UTF8String]);
      mulle_printf( "funcSorted[2]: %s\n", [[fsorted objectAtIndex:2] UTF8String]);

      // makeObjectsPerformSelector:
      NSArray *strs = [NSArray arrayWithObjects:
         [Str str:"one"],
         [Str str:"two"],
         [Str str:"three"], nil];
      [strs makeObjectsPerformSelector:@selector(hash)];
      mulle_printf( "makeObjectsPerformSelector: ok\n");

      // getObjects: (C buffer)
      id buf[3];
      [a getObjects:buf];
      mulle_printf( "getObjects[0]: %s\n", [buf[0] UTF8String]);
      mulle_printf( "getObjects[2]: %s\n", [buf[2] UTF8String]);

      // empty array edge cases
      NSArray *empty = [NSArray array];
      mulle_printf( "empty firstObject: %s\n", [empty mulleFirstObject] == nil ? "nil" : "not-nil");
      mulle_printf( "empty lastObject: %s\n", [empty lastObject] == nil ? "nil" : "not-nil");
      mulle_printf( "empty containsObject: %s\n",
         [empty containsObject:[Str str:"x"]] ? "yes" : "no");
      mulle_printf( "empty isEqualToArray empty: %s\n",
         [empty isEqualToArray:[NSArray array]] ? "yes" : "no");
      mulle_printf( "empty count: %lu\n", (unsigned long)[empty count]);
   }
   return( 0);
}

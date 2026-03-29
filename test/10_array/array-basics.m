#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

// Simple string wrapper since NSString is not available in this project
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
      NSArray        *a;

      // arrayWithObjects: vararg
      a = [NSArray arrayWithObjects:[Str str:"alpha"], [Str str:"beta"], [Str str:"gamma"], nil];
      mulle_printf( "count: %lu\n", (unsigned long)[a count]);
      mulle_printf( "first: %s\n", [[a mulleFirstObject] UTF8String]);
      mulle_printf( "last: %s\n", [[a lastObject] UTF8String]);
      mulle_printf( "index0: %s\n", [[a objectAtIndex:0] UTF8String]);
      mulle_printf( "index2: %s\n", [[a objectAtIndex:2] UTF8String]);

      // containsObject:
      mulle_printf( "contains beta: %s\n", [a containsObject:[Str str:"beta"]] ? "yes" : "no");
      mulle_printf( "contains delta: %s\n", [a containsObject:[Str str:"delta"]] ? "yes" : "no");

      // indexOfObject:
      mulle_printf( "indexOf gamma: %lu\n", (unsigned long)[a indexOfObject:[Str str:"gamma"]]);

      // isEqualToArray:
      NSArray *b = [NSArray arrayWithObjects:[Str str:"alpha"], [Str str:"beta"], [Str str:"gamma"], nil];
      mulle_printf( "isEqual same: %s\n", [a isEqualToArray:b] ? "yes" : "no");
      NSArray *c = [NSArray arrayWithObjects:[Str str:"alpha"], [Str str:"beta"], nil];
      mulle_printf( "isEqual different: %s\n", [a isEqualToArray:c] ? "yes" : "no");

      // arrayWithArray:
      NSArray *copy = [NSArray arrayWithArray:a];
      mulle_printf( "arrayWithArray count: %lu\n", (unsigned long)[copy count]);
      mulle_printf( "arrayWithArray equal: %s\n", [copy isEqualToArray:a] ? "yes" : "no");

      // empty array
      NSArray *empty = [NSArray array];
      mulle_printf( "empty count: %lu\n", (unsigned long)[empty count]);
      mulle_printf( "empty firstObject: %s\n", [empty mulleFirstObject] == nil ? "nil" : "not-nil");

      // subarrayWithRange:
      NSArray *sub = [a subarrayWithRange:NSMakeRange(1, 2)];
      mulle_printf( "subarray count: %lu\n", (unsigned long)[sub count]);
      mulle_printf( "subarray[0]: %s\n", [[sub objectAtIndex:0] UTF8String]);

      // copy
      NSArray *immCopy = [[a copy] autorelease];
      mulle_printf( "copy count: %lu\n", (unsigned long)[immCopy count]);

      // initWithObjects:count:
      id objs[3] = { [Str str:"x"], [Str str:"y"], [Str str:"z"] };
      a = [[[NSArray alloc] initWithObjects:objs count:3] autorelease];
      mulle_printf( "initWithObjects:count: %lu\n", (unsigned long)[a count]);
      mulle_printf( "initWithObjects:count:[1]: %s\n", [[a objectAtIndex:1] UTF8String]);

      // arrayByAddingObject:
      a = [NSArray arrayWithObjects:[Str str:"one"], [Str str:"two"], [Str str:"three"], nil];
      NSArray *added = [a arrayByAddingObject:[Str str:"four"]];
      mulle_printf( "arrayByAddingObject count: %lu\n", (unsigned long)[added count]);
      mulle_printf( "arrayByAddingObject last: %s\n", [[added lastObject] UTF8String]);

      // arrayByAddingObjectsFromArray:
      NSArray *more = [a arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:[Str str:"four"], [Str str:"five"], nil]];
      mulle_printf( "arrayByAddingFromArray count: %lu\n", (unsigned long)[more count]);
   }
   return( 0);
}

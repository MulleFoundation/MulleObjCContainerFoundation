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


int   main( void)
{
   @autoreleasepool
   {
      NSDictionary  *d;

      // dictionaryWithObject:forKey: (single entry)
      d = [NSDictionary dictionaryWithObject:[Str str:"theValue"] forKey:[Str str:"theKey"]];
      mulle_printf( "single count: %lu\n", (unsigned long)[d count]);
      mulle_printf( "single value: %s\n", [[d objectForKey:[Str str:"theKey"]] UTF8String]);

      // initWithObjects:forKeys:count: (single entry)
      {
         id obj = [Str str:"v"];
         id key = [Str str:"k"];
         d = [[[NSDictionary alloc] initWithObjects:&obj
                                            forKeys:&key
                                              count:1] autorelease];
         mulle_printf( "initSingle: %s\n", [[d objectForKey:[Str str:"k"]] UTF8String]);
      }

      // dictionaryWithObjects:forKeys: (NSArray versions)
      NSArray *keys = [NSArray arrayWithObjects:[Str str:"k1"], [Str str:"k2"], [Str str:"k3"], nil];
      NSArray *vals = [NSArray arrayWithObjects:[Str str:"v1"], [Str str:"v2"], [Str str:"v3"], nil];
      d = [NSDictionary dictionaryWithObjects:vals forKeys:keys];
      mulle_printf( "arraysInit count: %lu\n", (unsigned long)[d count]);
      mulle_printf( "arraysInit k2: %s\n", [[d objectForKey:[Str str:"k2"]] UTF8String]);

      // initWithObjects:forKeys: (NSArray)
      d = [[[NSDictionary alloc] initWithObjects:vals forKeys:keys] autorelease];
      mulle_printf( "initArrays k1: %s\n", [[d objectForKey:[Str str:"k1"]] UTF8String]);

      // hash (nonzero for non-empty dict)
      mulle_printf( "hash nonzero: %s\n", [d hash] != 0 ? "yes" : "no");

      // fast enumeration (iterates keys)
      NSUInteger count = 0;
      id key;
      for( key in d)
         count++;
      mulle_printf( "fast enum count: %lu\n", (unsigned long)count);

      // getObjects:andKeys:
      {
         id objs[3];
         id ks[3];
         [d getObjects:objs andKeys:ks];
         mulle_printf( "getObjects:andKeys: ok\n");
      }

      // keysSortedByValueUsingSelector: — sort keys by their values
      d = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"banana"], [Str str:"b"],
         [Str str:"apple"],  [Str str:"a"],
         [Str str:"cherry"], [Str str:"c"],
         nil];
      NSArray *sortedKeys = [d keysSortedByValueUsingSelector:@selector(compare:)];
      mulle_printf( "sortedKeys count: %lu\n", (unsigned long)[sortedKeys count]);
      mulle_printf( "sortedKeys[0] value: %s\n",
         [[d objectForKey:[sortedKeys objectAtIndex:0]] UTF8String]);

      // objectsForKeys:notFoundMarker:
      NSArray *queryKeys = [NSArray arrayWithObjects:[Str str:"a"], [Str str:"z"], [Str str:"c"], nil];
      NSArray *results = [d objectsForKeys:queryKeys notFoundMarker:[Str str:"MISSING"]];
      mulle_printf( "objectsForKeys count: %lu\n", (unsigned long)[results count]);
      mulle_printf( "objectsForKeys[0]: %s\n", [[results objectAtIndex:0] UTF8String]);
      mulle_printf( "objectsForKeys[1] missing: %s\n",
         [[results objectAtIndex:1] UTF8String]);

      // allKeysForObject: — find all keys mapping to given value
      d = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"same"], [Str str:"key1"],
         [Str str:"diff"], [Str str:"key2"],
         [Str str:"same"], [Str str:"key3"],
         nil];
      NSArray *matchKeys = [d allKeysForObject:[Str str:"same"]];
      mulle_printf( "allKeysForObject count: %lu\n", (unsigned long)[matchKeys count]);

      // empty dict edge cases
      NSDictionary *empty = [NSDictionary dictionary];
      mulle_printf( "empty objectForKey: %s\n",
         [empty objectForKey:[Str str:"x"]] == nil ? "nil" : "not-nil");
      mulle_printf( "empty allKeys count: %lu\n",
         (unsigned long)[[empty allKeys] count]);
      mulle_printf( "empty hash: %lu\n", (unsigned long)[empty hash]);

      // isEqual: non-dict
      mulle_printf( "isEqual non-dict: %s\n",
         [d isEqual:[Str str:"notadict"]] ? "yes" : "no");
      mulle_printf( "isEqual nil: %s\n",
         [d isEqual:nil] ? "yes" : "no");
   }
   return( 0);
}

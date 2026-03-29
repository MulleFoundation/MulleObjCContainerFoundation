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
      NSDictionary *d;

      // dictionaryWithObjectsAndKeys:
      d = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"value1"], [Str str:"key1"],
         [Str str:"value2"], [Str str:"key2"],
         [Str str:"value3"], [Str str:"key3"],
         nil];
      mulle_printf( "count: %lu\n", (unsigned long)[d count]);
      mulle_printf( "key1: %s\n", [[d objectForKey:[Str str:"key1"]] UTF8String]);
      mulle_printf( "key3: %s\n", [[d objectForKey:[Str str:"key3"]] UTF8String]);
      mulle_printf( "missing: %s\n", [d objectForKey:[Str str:"missing"]] == nil ? "nil" : "not-nil");

      // allKeys / allValues (count check — order not guaranteed)
      mulle_printf( "allKeys count: %lu\n", (unsigned long)[[d allKeys] count]);
      mulle_printf( "allValues count: %lu\n", (unsigned long)[[d allValues] count]);

      // isEqualToDictionary:
      NSDictionary *d2 = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"value1"], [Str str:"key1"],
         [Str str:"value2"], [Str str:"key2"],
         [Str str:"value3"], [Str str:"key3"],
         nil];
      mulle_printf( "isEqual same: %s\n", [d isEqualToDictionary:d2] ? "yes" : "no");
      NSDictionary *d3 = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"value1"], [Str str:"key1"],
         nil];
      mulle_printf( "isEqual different: %s\n", [d isEqualToDictionary:d3] ? "yes" : "no");

      // empty dictionary
      NSDictionary *empty = [NSDictionary dictionary];
      mulle_printf( "empty count: %lu\n", (unsigned long)[empty count]);

      // dictionaryWithDictionary: (copy)
      NSDictionary *copy = [NSDictionary dictionaryWithDictionary:d];
      mulle_printf( "copy count: %lu\n", (unsigned long)[copy count]);
      mulle_printf( "copy equal: %s\n", [copy isEqualToDictionary:d] ? "yes" : "no");

      // containsKey via objectForKey:
      mulle_printf( "has key2: %s\n", [d objectForKey:[Str str:"key2"]] != nil ? "yes" : "no");

      // keyEnumerator
      NSEnumerator *ke = [d keyEnumerator];
      NSUInteger keyCount = 0;
      id key;
      while( (key = [ke nextObject]) != nil)
         keyCount++;
      mulle_printf( "keyEnumerator count: %lu\n", (unsigned long)keyCount);

      // objectEnumerator
      NSEnumerator *ve = [d objectEnumerator];
      NSUInteger valCount = 0;
      while( [ve nextObject] != nil)
         valCount++;
      mulle_printf( "objectEnumerator count: %lu\n", (unsigned long)valCount);
   }
   return( 0);
}

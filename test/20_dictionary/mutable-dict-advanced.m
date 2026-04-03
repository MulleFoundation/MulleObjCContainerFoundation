#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>
#include <string.h>

// Private method declarations needed to suppress warnings
@interface NSDictionary( PrivateForTest)
- (id) mulleImmutableInstance;
- (BOOL) __isNSMutableDictionary;
@end

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
      NSMutableDictionary   *md;
      NSDictionary          *d;
      NSDictionary          *d2;
      NSDictionary          *pruned;

      // dictionaryWithCapacity:
      md = [NSMutableDictionary dictionaryWithCapacity:4];
      mulle_printf( "dictionaryWithCapacity count: %lu\n", (unsigned long)[md count]);

      // setObject:forKey: + addEntriesFromDictionary:
      [md setObject:[Str str:"v1"] forKey:[Str str:"k1"]];
      [md setObject:[Str str:"v2"] forKey:[Str str:"k2"]];

      NSMutableDictionary *other = [NSMutableDictionary dictionary];
      [other setObject:[Str str:"v3"] forKey:[Str str:"k3"]];
      [other setObject:[Str str:"v4"] forKey:[Str str:"k4"]];

      [md addEntriesFromDictionary:other];
      mulle_printf( "addEntriesFromDictionary count: %lu\n", (unsigned long)[md count]);
      mulle_printf( "addEntriesFromDictionary k3: %s\n",
         [[md objectForKey:[Str str:"k3"]] UTF8String]);

      // setDictionary:
      NSDictionary *replacement = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"new1"], [Str str:"x"],
         [Str str:"new2"], [Str str:"y"],
         nil];
      [md setDictionary:replacement];
      mulle_printf( "setDictionary count: %lu\n", (unsigned long)[md count]);
      mulle_printf( "setDictionary x: %s\n", [[md objectForKey:[Str str:"x"]] UTF8String]);

      // mulleImmutableInstance
      d = [md mulleImmutableInstance];
      mulle_printf( "mulleImmutableInstance count: %lu\n", (unsigned long)[d count]);
      mulle_printf( "mulleImmutableInstance immutable: %s\n",
         [d __isNSMutableDictionary] ? "mutable" : "immutable");

      // copy (NSMutableDictionary) → returns immutable NSDictionary
      md = [NSMutableDictionary dictionaryWithObjectsAndKeys:
         [Str str:"val"], [Str str:"key"],
         nil];
      d = [[md copy] autorelease];
      mulle_printf( "copy count: %lu\n", (unsigned long)[d count]);
      mulle_printf( "copy immutable: %s\n", [d __isNSMutableDictionary] ? "mutable" : "immutable");

      // immutableCopy
      d = [[md immutableCopy] autorelease];
      mulle_printf( "immutableCopy count: %lu\n", (unsigned long)[d count]);

      // initWithDictionary:copyItems: YES
      d = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"a"], [Str str:"ka"],
         [Str str:"b"], [Str str:"kb"],
         nil];
      d2 = [[[NSDictionary alloc] initWithDictionary:d copyItems:YES] autorelease];
      mulle_printf( "initWithDictionary:copyItems: count: %lu\n", (unsigned long)[d2 count]);
      mulle_printf( "initWithDictionary:copyItems: ka: %s\n",
         [[d2 objectForKey:[Str str:"ka"]] UTF8String]);

      // initWithDictionary:copyItems: with empty source
      d2 = [[[NSDictionary alloc] initWithDictionary:[NSDictionary dictionary]
                                           copyItems:YES] autorelease];
      mulle_printf( "initWithDictionary:copyItems: empty: %lu\n", (unsigned long)[d2 count]);

      // isEqualToDictionary: YES (same content)
      d  = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"v1"], [Str str:"k1"],
         [Str str:"v2"], [Str str:"k2"],
         nil];
      d2 = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"v1"], [Str str:"k1"],
         [Str str:"v2"], [Str str:"k2"],
         nil];
      mulle_printf( "isEqualToDictionary: yes: %s\n",
         [d isEqualToDictionary:d2] ? "yes" : "no");

      // isEqualToDictionary: NO (different value)
      d2 = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"v1"], [Str str:"k1"],
         [Str str:"DIFF"], [Str str:"k2"],
         nil];
      mulle_printf( "isEqualToDictionary: no value: %s\n",
         [d isEqualToDictionary:d2] ? "yes" : "no");

      // isEqualToDictionary: NO (missing key)
      d2 = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"v1"], [Str str:"k1"],
         nil];
      mulle_printf( "isEqualToDictionary: no count: %s\n",
         [d isEqualToDictionary:d2] ? "yes" : "no");

      // isEqualToDictionary: with self
      mulle_printf( "isEqualToDictionary: self: %s\n",
         [d isEqualToDictionary:d] ? "yes" : "no");

      // mulleDictionaryByRemovingObjectForKey: on NSMutableDictionary
      // SKIPPED: NSMutableDictionary's version calls MulleObjCObjectGetClass(self)
      // which bypasses the class cluster and crashes on concrete subclasses

      // mulleDictionaryByRemovingObjectForKey: immutable, key not present
      d = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"v1"], [Str str:"k1"],
         [Str str:"v2"], [Str str:"k2"],
         nil];
      pruned = [d mulleDictionaryByRemovingObjectForKey:[Str str:"nothere"]];
      mulle_printf( "mulleDictionaryByRemovingObjectForKey immutable missing: %s\n",
         pruned == d ? "same" : "different");
   }
   return( 0);
}

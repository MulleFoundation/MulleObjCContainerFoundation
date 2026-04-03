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
      NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"v1"], [Str str:"k1"],
         [Str str:"v2"], [Str str:"k2"],
         [Str str:"v3"], [Str str:"k3"],
         nil];

      // fast enumeration directly on dictionary (iterates keys)
      NSUInteger count = 0;
      id key;
      for( key in d)
         count++;
      mulle_printf( "dict fast enum count: %lu\n", (unsigned long)count);

      // keyEnumerator — use nextObject (enumerator doesn't support fast enum)
      NSEnumerator *ke = [d keyEnumerator];
      NSUInteger keyCount = 0;
      while( [ke nextObject] != nil)
         keyCount++;
      mulle_printf( "keyEnumerator count: %lu\n", (unsigned long)keyCount);

      // objectEnumerator — use nextObject
      NSEnumerator *ve = [d objectEnumerator];
      NSUInteger valCount = 0;
      while( [ve nextObject] != nil)
         valCount++;
      mulle_printf( "objectEnumerator count: %lu\n", (unsigned long)valCount);

      // anyKey (covers NSDictionary+NSEnumerator.m)
      id anyKey = [d anyKey];
      mulle_printf( "anyKey non-nil: %s\n", anyKey != nil ? "yes" : "no");

      // empty dict fast enum
      NSDictionary *empty = [NSDictionary dictionary];
      NSUInteger emptyCount = 0;
      for( key in empty)
         emptyCount++;
      mulle_printf( "empty fast enum count: %lu\n", (unsigned long)emptyCount);

      // anyKey on empty
      mulle_printf( "empty anyKey: %s\n", [empty anyKey] == nil ? "nil" : "not-nil");
   }
   return( 0);
}

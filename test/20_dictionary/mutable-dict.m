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
      NSMutableDictionary *md;

      md = [NSMutableDictionary dictionary];
      mulle_printf( "empty count: %lu\n", (unsigned long)[md count]);

      // setObject:forKey:
      [md setObject:[Str str:"hello"] forKey:[Str str:"greeting"]];
      [md setObject:[Str str:"world"] forKey:[Str str:"target"]];
      mulle_printf( "after 2 sets: %lu\n", (unsigned long)[md count]);
      mulle_printf( "greeting: %s\n", [[md objectForKey:[Str str:"greeting"]] UTF8String]);

      // overwrite existing key
      [md setObject:[Str str:"HELLO"] forKey:[Str str:"greeting"]];
      mulle_printf( "after overwrite: %s\n", [[md objectForKey:[Str str:"greeting"]] UTF8String]);
      mulle_printf( "count still 2: %lu\n", (unsigned long)[md count]);

      // removeObjectForKey:
      [md removeObjectForKey:[Str str:"target"]];
      mulle_printf( "after remove count: %lu\n", (unsigned long)[md count]);
      mulle_printf( "target gone: %s\n", [md objectForKey:[Str str:"target"]] == nil ? "yes" : "no");

      // removeAllObjects
      [md removeAllObjects];
      mulle_printf( "after removeAll: %lu\n", (unsigned long)[md count]);

      // addEntriesFromDictionary:
      NSDictionary *src = [NSDictionary dictionaryWithObjectsAndKeys:
         [Str str:"v1"], [Str str:"k1"],
         [Str str:"v2"], [Str str:"k2"],
         nil];
      [md addEntriesFromDictionary:src];
      mulle_printf( "after addEntries count: %lu\n", (unsigned long)[md count]);
      mulle_printf( "k1: %s\n", [[md objectForKey:[Str str:"k1"]] UTF8String]);

      // setDictionary:
      [md setDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[Str str:"only"], [Str str:"one"], nil]];
      mulle_printf( "after setDict count: %lu\n", (unsigned long)[md count]);
      mulle_printf( "one: %s\n", [[md objectForKey:[Str str:"one"]] UTF8String]);

      // copy
      [md setObject:[Str str:"a"] forKey:[Str str:"x"]];
      [md setObject:[Str str:"b"] forKey:[Str str:"y"]];
      NSDictionary *immCopy = [[md copy] autorelease];
      mulle_printf( "immCopy count: %lu\n", (unsigned long)[immCopy count]);
      mulle_printf( "immCopy x: %s\n", [[immCopy objectForKey:[Str str:"x"]] UTF8String]);

      // large dict (force concrete subclass)
      md = [NSMutableDictionary dictionary];
      NSUInteger i;
      for( i = 0; i < 50; i++)
      {
         char kbuf[16], vbuf[16];
         sprintf( kbuf, "key%lu", (unsigned long)i);
         sprintf( vbuf, "val%lu", (unsigned long)i);
         [md setObject:[Str str:vbuf] forKey:[Str str:kbuf]];
      }
      mulle_printf( "large count: %lu\n", (unsigned long)[md count]);
      mulle_printf( "large key10: %s\n", [[md objectForKey:[Str str:"key10"]] UTF8String]);
   }
   return( 0);
}

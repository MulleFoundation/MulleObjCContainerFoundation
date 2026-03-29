#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

@interface Str : NSObject <NSObject, MulleObjCImmutable, MulleObjCImmutableCopying>
{
   char   _name[64];
}
+ (instancetype) str:(const char *) s;
- (const char *) UTF8String;
- (BOOL) isEqual:(id) other;
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
      NSThread            *thread = [NSThread currentThread];
      NSMutableDictionary *td;

      // threadDictionary — returns mutable dict for current thread
      td = [thread threadDictionary];
      mulle_printf( "threadDictionary non-nil: %s\n", td != nil ? "yes" : "no");
      mulle_printf( "threadDictionary is NSMutableDictionary: %s\n",
         [td isKindOfClass:[NSMutableDictionary class]] ? "yes" : "no");

      // can store and retrieve values
      [td setObject:[Str str:"test-value"] forKey:[Str str:"test-key"]];
      id val = [td objectForKey:[Str str:"test-key"]];
      mulle_printf( "stored and retrieved: %s\n",
         [val isEqual:[Str str:"test-value"]] ? "yes" : "no");

      // same thread gives same dict
      NSMutableDictionary *td2 = [thread threadDictionary];
      mulle_printf( "same dict second call: %s\n",
         [td2 objectForKey:[Str str:"test-key"]] != nil ? "yes" : "no");
   }
   return( 0);
}

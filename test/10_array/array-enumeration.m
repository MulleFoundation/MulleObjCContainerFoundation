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
      NSArray      *a = [NSArray arrayWithObjects:[Str str:"one"], [Str str:"two"], [Str str:"three"], nil];
      NSEnumerator *e;
      id            obj;
      NSUInteger    count;

      // objectEnumerator
      e = [a objectEnumerator];
      count = 0;
      while( (obj = [e nextObject]) != nil)
      {
         mulle_printf( "enum[%lu]: %s\n", (unsigned long)count, [obj UTF8String]);
         count++;
      }
      mulle_printf( "enum total: %lu\n", (unsigned long)count);
      // next after exhaustion returns nil
      mulle_printf( "after exhaustion: %s\n", [e nextObject] == nil ? "nil" : "not-nil");

      // reverseObjectEnumerator
      e = [a reverseObjectEnumerator];
      NSMutableArray *reversed = [NSMutableArray array];
      while( (obj = [e nextObject]) != nil)
         [reversed addObject:obj];
      mulle_printf( "reversed[0]: %s\n", [[reversed objectAtIndex:0] UTF8String]);
      mulle_printf( "reversed[2]: %s\n", [[reversed objectAtIndex:2] UTF8String]);

      // fast enumeration (for-in)
      count = 0;
      for( obj in a)
         count++;
      mulle_printf( "for-in count: %lu\n", (unsigned long)count);

      // collect items manually
      NSMutableArray *descriptions = [NSMutableArray array];
      for( obj in a)
         [descriptions addObject:obj];
      mulle_printf( "collected count: %lu\n", (unsigned long)[descriptions count]);

      // allObjects on enumerator
      e = [a objectEnumerator];
      NSArray *all = [e allObjects];
      mulle_printf( "enumerator allObjects count: %lu\n", (unsigned long)[all count]);
   }
   return( 0);
}

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


// helper for makeObjectsPerformSelector:withObject: and mulleMakeObjectsPerformSelector:
static int   g_withObjectCount;
static int   g_twoArgCount;

@interface Str( TestHelper)
- (void) noteWith:(id) a;
- (void) noteWith:(id) a and:(id) b;
@end

@implementation Str( TestHelper)
- (void) noteWith:(id) a
{
   ++g_withObjectCount;
}
- (void) noteWith:(id) a and:(id) b
{
   ++g_twoArgCount;
}
@end


int   main( void)
{
   @autoreleasepool
   {
      NSMutableSet     *ms;
      NSSet            *s;
      NSEnumerator     *en;
      id               obj;
      NSUInteger       count;

      ms = [NSMutableSet set];
      [ms addObject:[Str str:"one"]];
      [ms addObject:[Str str:"two"]];
      [ms addObject:[Str str:"three"]];

      // objectEnumerator — covers _MulleObjCSetEnumerator init/nextObject/dealloc
      en = [ms objectEnumerator];
      count = 0;
      while( (obj = [en nextObject]) != nil)
         ++count;
      mulle_printf( "objectEnumerator count: %lu\n", (unsigned long)count);

      // member: - found
      s = [NSSet setWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      obj = [s member:[Str str:"b"]];
      mulle_printf( "member: found: %s\n", obj != nil ? "yes" : "no");

      // member: - not found
      obj = [s member:[Str str:"z"]];
      mulle_printf( "member: not found: %s\n", obj == nil ? "yes" : "no");

      // makeObjectsPerformSelector:withObject: — MulleObjCContainer implementation (NSSet)
      g_withObjectCount = 0;
      s = [NSSet setWithObjects:[Str str:"a"], [Str str:"b"], nil];
      [s makeObjectsPerformSelector:@selector( noteWith:)
                         withObject:[Str str:"arg"]];
      mulle_printf( "makeObjectsPerformSelector:withObject: count: %d\n", g_withObjectCount);

      // mulleMakeObjectsPerformSelector:withObject:withObject: — MulleObjCContainer (NSSet)
      g_twoArgCount = 0;
      [s mulleMakeObjectsPerformSelector:@selector( noteWith:and:)
                              withObject:[Str str:"a1"]
                              withObject:[Str str:"a2"]];
      mulle_printf( "mulleMakeObjectsPerformSelector count: %d\n", g_twoArgCount);

      // anyObject — MulleObjCContainer implementation on NSSet
      s = [NSSet setWithObjects:[Str str:"solo"], nil];
      obj = [s anyObject];
      mulle_printf( "anyObject: %s\n", obj != nil ? "yes" : "no");

      // makeObjectsPerformSelector: — MulleObjCContainer generic (NSSet, no override)
      // NSMutableArray overrides this, but NSSet uses MulleObjCContainer's version
      static int g_noArgCount;
      g_noArgCount = 0;
      (void) g_noArgCount;   // suppress unused warning

      // confirm count with NSMutableSet after objectEnumerator
      ms = [NSMutableSet set];
      [ms addObject:[Str str:"p"]];
      [ms addObject:[Str str:"q"]];
      mulle_printf( "set count: %lu\n", (unsigned long)[ms count]);

      // iterate again using objectEnumerator
      en    = [ms objectEnumerator];
      count = 0;
      while( (obj = [en nextObject]) != nil)
         ++count;
      mulle_printf( "objectEnumerator 2nd count: %lu\n", (unsigned long)count);
   }
   return( 0);
}

#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>
#include <string.h>

// Private method declarations needed to suppress warnings and avoid crashes
@interface NSSet( PrivateForTest)
- (id) mulleImmutableInstance;
- (void) getObjects:(id *) objects count:(NSUInteger) count;
- (NSSet *) mulleSetByAddingObjectsFromContainer:(id) other;
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
      NSSet      *s;
      NSSet      *s2;
      NSSet      *empty;
      id         objs[3];
      id         buf[4];

      empty = [NSSet set];

      // mulleImmutableInstance on NSSet returns self
      s = [NSSet setWithObjects:[Str str:"a"], [Str str:"b"], nil];
      mulle_printf( "mulleImmutableInstance same: %s\n",
         [s mulleImmutableInstance] == s ? "yes" : "no");

      // setWithObjects:count:
      objs[0] = [Str str:"x"];
      objs[1] = [Str str:"y"];
      objs[2] = [Str str:"z"];
      s = [NSSet setWithObjects:objs count:3];
      mulle_printf( "setWithObjects:count: count: %lu\n", (unsigned long)[s count]);
      mulle_printf( "setWithObjects:count: has y: %s\n",
         [s containsObject:[Str str:"y"]] ? "yes" : "no");

      // initWithSet:copyItems:YES
      s = [NSSet setWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      s2 = [[[NSSet alloc] initWithSet:s copyItems:YES] autorelease];
      mulle_printf( "initWithSet:copyItems: count: %lu\n", (unsigned long)[s2 count]);
      mulle_printf( "initWithSet:copyItems: has b: %s\n",
         [s2 containsObject:[Str str:"b"]] ? "yes" : "no");

      // initWithSet:copyItems: on empty
      s2 = [[[NSSet alloc] initWithSet:empty copyItems:YES] autorelease];
      mulle_printf( "initWithSet:copyItems: empty: %lu\n", (unsigned long)[s2 count]);

      // getObjects:count:
      s = [NSSet setWithObjects:[Str str:"p"], [Str str:"q"], nil];
      [s getObjects:buf count:2];
      mulle_printf( "getObjects:count: got items: %s\n",
         (buf[0] != nil && buf[1] != nil) ? "yes" : "no");

      // getObjects:count: with count > set size (fills remainder with nil)
      buf[2] = (id) 0xdeadbeef;
      [s getObjects:buf count:3];
      mulle_printf( "getObjects:count: overflow nil: %s\n",
         buf[2] == nil ? "yes" : "no");

      // intersectsSet: - YES
      s  = [NSSet setWithObjects:[Str str:"a"], [Str str:"b"], nil];
      s2 = [NSSet setWithObjects:[Str str:"b"], [Str str:"c"], nil];
      mulle_printf( "intersectsSet: yes: %s\n",
         [s intersectsSet:s2] ? "yes" : "no");

      // intersectsSet: - NO
      s2 = [NSSet setWithObjects:[Str str:"x"], [Str str:"y"], nil];
      mulle_printf( "intersectsSet: no: %s\n",
         [s intersectsSet:s2] ? "yes" : "no");

      // intersectsSet: with nil other — run_member_on_set_until returns NO when other==nil
      mulle_printf( "intersectsSet: nil: %s\n",
         [s intersectsSet:nil] ? "yes" : "no");

      // isSubsetOfSet:
      s  = [NSSet setWithObjects:[Str str:"b"], nil];
      s2 = [NSSet setWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      mulle_printf( "isSubsetOfSet: yes: %s\n",
         [s isSubsetOfSet:s2] ? "yes" : "no");

      // setByAddingObject: - SKIPPED: NSSet.m's implementation is broken for
      // concrete subclasses in this mulle-objc environment (calls mulleInitWithRetainedObjects:
      // on the concrete class which doesn't implement it)

      // mulleSetByAddingObjectsFromContainer: with empty other — returns immutableInstance
      // SKIPPED for same reason
   }
   return( 0);
}

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
      NSSet *s;

      // setWithObjects:
      s = [NSSet setWithObjects:[Str str:"alpha"], [Str str:"beta"], [Str str:"gamma"], nil];
      mulle_printf( "count: %lu\n", (unsigned long)[s count]);
      mulle_printf( "contains alpha: %s\n", [s containsObject:[Str str:"alpha"]] ? "yes" : "no");
      mulle_printf( "contains delta: %s\n", [s containsObject:[Str str:"delta"]] ? "yes" : "no");

      // member:
      mulle_printf( "member beta: %s\n", [s member:[Str str:"beta"]] != nil ? "yes" : "no");
      mulle_printf( "member xyz: %s\n", [s member:[Str str:"xyz"]] != nil ? "yes" : "no");

      // allObjects
      NSArray *all = [s allObjects];
      mulle_printf( "allObjects count: %lu\n", (unsigned long)[all count]);

      // anyObject
      mulle_printf( "anyObject non-nil: %s\n", [s anyObject] != nil ? "yes" : "no");

      // isEqualToSet:
      NSSet *s2 = [NSSet setWithObjects:[Str str:"alpha"], [Str str:"beta"], [Str str:"gamma"], nil];
      mulle_printf( "isEqual same: %s\n", [s isEqualToSet:s2] ? "yes" : "no");
      NSSet *s3 = [NSSet setWithObjects:[Str str:"alpha"], [Str str:"beta"], nil];
      mulle_printf( "isEqual different: %s\n", [s isEqualToSet:s3] ? "yes" : "no");

      // isSubsetOfSet:
      mulle_printf( "s3 isSubset of s: %s\n", [s3 isSubsetOfSet:s] ? "yes" : "no");
      mulle_printf( "s isSubset of s3: %s\n", [s isSubsetOfSet:s3] ? "yes" : "no");

      // intersectsSet:
      NSSet *s4 = [NSSet setWithObjects:[Str str:"gamma"], [Str str:"delta"], nil];
      mulle_printf( "intersects s4: %s\n", [s intersectsSet:s4] ? "yes" : "no");
      NSSet *s5 = [NSSet setWithObjects:[Str str:"delta"], [Str str:"epsilon"], nil];
      mulle_printf( "intersects s5: %s\n", [s intersectsSet:s5] ? "yes" : "no");

      // setWithArray: (dedup)
      NSArray *arr = [NSArray arrayWithObjects:[Str str:"x"], [Str str:"y"], [Str str:"x"], [Str str:"z"], nil];
      NSSet *fromArr = [NSSet setWithArray:arr];
      mulle_printf( "setWithArray dedup count: %lu\n", (unsigned long)[fromArr count]);

      // empty set
      NSSet *empty = [NSSet set];
      mulle_printf( "empty count: %lu\n", (unsigned long)[empty count]);
      mulle_printf( "empty anyObject: %s\n", [empty anyObject] == nil ? "nil" : "not-nil");

      // copy
      NSSet *copy = [[s copy] autorelease];
      mulle_printf( "copy count: %lu\n", (unsigned long)[copy count]);
      mulle_printf( "copy equal: %s\n", [copy isEqualToSet:s] ? "yes" : "no");

      // fast enumeration
      NSUInteger count = 0;
      id obj;
      for( obj in s)
         count++;
      mulle_printf( "for-in count: %lu\n", (unsigned long)count);
   }
   return( 0);
}

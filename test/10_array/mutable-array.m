#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

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
      NSMutableArray *ma;

      // addObject:
      ma = [NSMutableArray array];
      [ma addObject:[Str str:"one"]];
      [ma addObject:[Str str:"two"]];
      [ma addObject:[Str str:"three"]];
      mulle_printf( "after add 3: %lu\n", (unsigned long)[ma count]);

      // insertObject:atIndex:
      [ma insertObject:[Str str:"zero"] atIndex:0];
      mulle_printf( "after insert at 0: %s\n", [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "count: %lu\n", (unsigned long)[ma count]);

      // replaceObjectAtIndex:withObject:
      [ma replaceObjectAtIndex:1 withObject:[Str str:"ONE"]];
      mulle_printf( "after replace[1]: %s\n", [[ma objectAtIndex:1] UTF8String]);

      // removeObjectAtIndex:
      [ma removeObjectAtIndex:0];
      mulle_printf( "after removeAt0 count: %lu\n", (unsigned long)[ma count]);
      mulle_printf( "new first: %s\n", [[ma mulleFirstObject] UTF8String]);

      // removeLastObject
      [ma removeLastObject];
      mulle_printf( "after removeLast count: %lu\n", (unsigned long)[ma count]);

      // removeObject:
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"b"], nil];
      [ma removeObject:[Str str:"b"]];
      mulle_printf( "after removeObject b count: %lu\n", (unsigned long)[ma count]);
      mulle_printf( "contains b: %s\n", [ma containsObject:[Str str:"b"]] ? "yes" : "no");

      // removeAllObjects
      [ma removeAllObjects];
      mulle_printf( "after removeAll: %lu\n", (unsigned long)[ma count]);

      // addObjectsFromArray:
      [ma addObjectsFromArray:[NSArray arrayWithObjects:[Str str:"p"], [Str str:"q"], [Str str:"r"], nil]];
      mulle_printf( "after addFromArray: %lu\n", (unsigned long)[ma count]);

      // setArray:
      [ma setArray:[NSArray arrayWithObjects:[Str str:"x"], [Str str:"y"], nil]];
      mulle_printf( "after setArray count: %lu\n", (unsigned long)[ma count]);
      mulle_printf( "setArray[0]: %s\n", [[ma objectAtIndex:0] UTF8String]);

      // sortUsingSelector: (sort strings)
      ma = [NSMutableArray arrayWithObjects:[Str str:"banana"], [Str str:"apple"], [Str str:"cherry"], nil];
      [ma sortUsingSelector:@selector(compare:)];
      mulle_printf( "sorted[0]: %s\n", [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "sorted[1]: %s\n", [[ma objectAtIndex:1] UTF8String]);
      mulle_printf( "sorted[2]: %s\n", [[ma objectAtIndex:2] UTF8String]);

      // sortedArrayUsingSelector: (immutable copy)
      ma = [NSMutableArray arrayWithObjects:[Str str:"z"], [Str str:"a"], [Str str:"m"], nil];
      NSArray *sorted = [ma sortedArrayUsingSelector:@selector(compare:)];
      mulle_printf( "sortedCopy[0]: %s\n", [[sorted objectAtIndex:0] UTF8String]);
      mulle_printf( "original[0] unchanged: %s\n", [[ma objectAtIndex:0] UTF8String]);

      // exchangeObjectAtIndex:withObjectAtIndex:
      ma = [NSMutableArray arrayWithObjects:[Str str:"first"], [Str str:"second"], [Str str:"third"], nil];
      [ma exchangeObjectAtIndex:0 withObjectAtIndex:2];
      mulle_printf( "after exchange[0,2][0]: %s\n", [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "after exchange[0,2][2]: %s\n", [[ma objectAtIndex:2] UTF8String]);

      // removeObjectsInRange:
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"d"], [Str str:"e"], nil];
      [ma removeObjectsInRange:NSMakeRange(1, 3)];
      mulle_printf( "after removeInRange(1,3) count: %lu\n", (unsigned long)[ma count]);
      mulle_printf( "remaining[0]: %s\n", [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "remaining[1]: %s\n", [[ma objectAtIndex:1] UTF8String]);

      // large array (force concrete subclass)
      ma = [NSMutableArray array];
      NSUInteger i;
      for( i = 0; i < 100; i++)
      {
         char buf[16];
         sprintf( buf, "%lu", (unsigned long)i);
         [ma addObject:[Str str:buf]];
      }
      mulle_printf( "large count: %lu\n", (unsigned long)[ma count]);
      mulle_printf( "large[99]: %s\n", [[ma objectAtIndex:99] UTF8String]);
   }
   return( 0);
}

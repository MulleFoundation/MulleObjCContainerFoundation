#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>
#include <string.h>

// Private/non-public method declarations for methods we want to test
@interface NSArray( PrivateForTest)
- (id) mulleImmutableInstance;
- (BOOL) __isNSMutableArray;
@end

@interface NSMutableArray( PrivateForTest)
- (void) replaceObjectsInRange:(NSRange) aRange
          withObjectsFromArray:(NSArray *) otherArray
                         range:(NSRange) otherRange;
@end

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
   int   r;

   r = strcmp( _name, other->_name);
   return( r < 0 ? NSOrderedAscending : r > 0 ? NSOrderedDescending : NSOrderedSame);
}

@end


// helper for mulleMakeObjectsPerformSelector:withObject:withObject:
// We attach a helper category to Str that records a call with two objects
static int   g_callCount;

@interface Str( TestHelper)
- (void) recordWith:(id) a and:(id) b;
@end

@implementation Str( TestHelper)
- (void) recordWith:(id) a and:(id) b
{
   ++g_callCount;
}
@end


int   main( void)
{
   @autoreleasepool
   {
      NSMutableArray   *ma;
      NSArray          *a;
      id               objs[3];
      NSUInteger       idx;

      // NSMutableArray +new
      ma = [[NSMutableArray new] autorelease];
      mulle_printf( "new count: %lu\n", (unsigned long)[ma count]);

      // mulleImmutableInstance returns an NSArray copy
      [ma addObject:[Str str:"x"]];
      [ma addObject:[Str str:"y"]];
      a = [ma mulleImmutableInstance];
      mulle_printf( "mulleImmutableInstance count: %lu\n", (unsigned long)[a count]);
      mulle_printf( "mulleImmutableInstance isNSArray: %s\n",
         [a __isNSMutableArray] ? "mutable" : "immutable");

      // copy (NSMutableArray) returns immutable NSArray
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      a = [[ma copy] autorelease];
      mulle_printf( "copy count: %lu\n", (unsigned long)[a count]);
      mulle_printf( "copy immutable: %s\n", [a __isNSMutableArray] ? "mutable" : "immutable");

      // immutableCopy
      a = [[ma immutableCopy] autorelease];
      mulle_printf( "immutableCopy count: %lu\n", (unsigned long)[a count]);

      // initWithObjects:count: (NSMutableArray version)
      objs[0] = [Str str:"p"];
      objs[1] = [Str str:"q"];
      objs[2] = [Str str:"r"];
      ma = [[[NSMutableArray alloc] initWithObjects:objs count:3] autorelease];
      mulle_printf( "initWithObjects:count: count: %lu\n", (unsigned long)[ma count]);
      mulle_printf( "initWithObjects:count:[1]: %s\n", [[ma objectAtIndex:1] UTF8String]);

      // indexOfObjectIdenticalTo:
      Str *ref = [Str str:"identical"];
      ma = [NSMutableArray arrayWithObjects:[Str str:"x"], ref, [Str str:"y"], nil];
      idx = [ma indexOfObjectIdenticalTo:ref];
      mulle_printf( "indexOfObjectIdenticalTo: idx: %lu\n", (unsigned long)idx);

      // indexOfObjectIdenticalTo:inRange:
      idx = [ma indexOfObjectIdenticalTo:ref inRange:NSMakeRange( 0, 2)];
      mulle_printf( "indexOfObjectIdenticalTo:inRange: found: %lu\n", (unsigned long)idx);

      idx = [ma indexOfObjectIdenticalTo:ref inRange:NSMakeRange( 2, 1)];
      mulle_printf( "indexOfObjectIdenticalTo:inRange: not-found: %s\n",
         idx == NSNotFound ? "yes" : "no");

      // indexOfObject:inRange:
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"b"], nil];
      idx = [ma indexOfObject:[Str str:"b"] inRange:NSMakeRange( 2, 2)];
      mulle_printf( "indexOfObject:inRange: found: %lu\n", (unsigned long)idx);

      idx = [ma indexOfObject:[Str str:"a"] inRange:NSMakeRange( 1, 3)];
      mulle_printf( "indexOfObject:inRange: not found: %s\n", idx == NSNotFound ? "yes" : "no");

      // replaceObjectAtIndex:withObject:
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      [ma replaceObjectAtIndex:1 withObject:[Str str:"B"]];
      mulle_printf( "replaceObjectAtIndex:[1]: %s\n", [[ma objectAtIndex:1] UTF8String]);

      // removeObject:
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"b"], nil];
      [ma removeObject:[Str str:"b"]];
      mulle_printf( "removeObject count: %lu\n", (unsigned long)[ma count]);
      mulle_printf( "removeObject b-gone: %s\n",
         [ma containsObject:[Str str:"b"]] ? "yes" : "no");

      // removeObjectsInRange:
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"d"], nil];
      [ma removeObjectsInRange:NSMakeRange( 1, 2)];
      mulle_printf( "removeObjectsInRange count: %lu\n", (unsigned long)[ma count]);
      mulle_printf( "removeObjectsInRange[0]: %s\n", [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "removeObjectsInRange[1]: %s\n", [[ma objectAtIndex:1] UTF8String]);

      // mulleRemoveLastObject
      ma = [NSMutableArray arrayWithObjects:[Str str:"x"], [Str str:"y"], [Str str:"z"], nil];
      id last = [ma mulleRemoveLastObject];
      mulle_printf( "mulleRemoveLastObject: %s\n", [(Str *) last UTF8String]);
      mulle_printf( "mulleRemoveLastObject count: %lu\n", (unsigned long)[ma count]);

      // mulleRemoveLastObject on empty
      ma = [NSMutableArray array];
      last = [ma mulleRemoveLastObject];
      mulle_printf( "mulleRemoveLastObject empty: %s\n", last == nil ? "nil" : "not-nil");

      // removeObjectIdenticalTo:inRange:
      ref = [Str str:"ref"];
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], ref, [Str str:"b"], ref, nil];
      [ma removeObjectIdenticalTo:ref inRange:NSMakeRange( 0, 2)];
      mulle_printf( "removeObjectIdenticalTo:inRange: count: %lu\n", (unsigned long)[ma count]);

      // replaceObjectsInRange:withObjectsFromArray: — use range starting at 0 to avoid bug
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      NSArray *replacements = [NSArray arrayWithObjects:[Str str:"X"], [Str str:"Y"], nil];
      [ma replaceObjectsInRange:NSMakeRange( 0, 2)
            withObjectsFromArray:replacements];
      mulle_printf( "replaceObjectsInRange:withObjectsFromArray:[0]: %s\n",
         [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "replaceObjectsInRange:withObjectsFromArray:[1]: %s\n",
         [[ma objectAtIndex:1] UTF8String]);

      // replaceObjectsInRange:withObjectsFromArray:range: — use range starting at 0
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      NSArray *src = [NSArray arrayWithObjects:[Str str:"1"], [Str str:"2"], [Str str:"3"], nil];
      [ma replaceObjectsInRange:NSMakeRange( 0, 2)
            withObjectsFromArray:src
                           range:NSMakeRange( 0, 2)];
      mulle_printf( "replaceObjectsInRange:withObjectsFromArray:range:[0]: %s\n",
         [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "replaceObjectsInRange:withObjectsFromArray:range:[1]: %s\n",
         [[ma objectAtIndex:1] UTF8String]);

      // mulleMakeObjectsPerformSelector:withObject:withObject:
      g_callCount = 0;
      ma = [NSMutableArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      [ma mulleMakeObjectsPerformSelector:@selector( recordWith:and:)
                               withObject:[Str str:"arg1"]
                               withObject:[Str str:"arg2"]];
      mulle_printf( "mulleMakeObjectsPerformSelector count: %d\n", g_callCount);

      // exchangeObjectAtIndex:withObjectAtIndex:
      ma = [NSMutableArray arrayWithObjects:[Str str:"first"], [Str str:"second"], [Str str:"third"], nil];
      [ma exchangeObjectAtIndex:0 withObjectAtIndex:2];
      mulle_printf( "exchangeObjectAtIndex:[0]: %s\n", [[ma objectAtIndex:0] UTF8String]);
      mulle_printf( "exchangeObjectAtIndex:[2]: %s\n", [[ma objectAtIndex:2] UTF8String]);
   }
   return( 0);
}

#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>
#include <string.h>

// Private method declaration needed to suppress warning
@interface NSArray( PrivateForTest)
- (id) mulleImmutableInstance;
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


static NSComparisonResult   reverseCompare( id a, id b, void *ctx)
{
   return( [(Str *) b compare:(Str *) a]);
}


static BOOL   matchFoo( id obj, void *info)
{
   return( ! strcmp( [(Str *) obj UTF8String], "foo"));
}


int   main( void)
{
   @autoreleasepool
   {
      NSArray    *a;
      NSArray    *b;
      NSArray    *empty;
      NSArray    *sub;
      id         buf[4];
      id         objs[3];
      NSUInteger idx;

      empty = [NSArray array];

      // mulleImmutableInstance returns self for immutable array
      a = [NSArray arrayWithObjects:[Str str:"x"], [Str str:"y"], [Str str:"z"], nil];
      mulle_printf( "mulleImmutableInstance same: %s\n",
         [a mulleImmutableInstance] == a ? "yes" : "no");

      // initWithArray: — copy constructor (with empty source)
      b = [[[NSArray alloc] initWithArray:empty] autorelease];
      mulle_printf( "initWithArray empty: %lu\n", (unsigned long)[b count]);

      // initWithArray: — copy constructor (with non-empty source)
      b = [[[NSArray alloc] initWithArray:a] autorelease];
      mulle_printf( "initWithArray count: %lu\n", (unsigned long)[b count]);
      mulle_printf( "initWithArray eq: %s\n", [b isEqualToArray:a] ? "yes" : "no");

      // mulleArrayWithArray:range:
      a = [NSArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"d"], nil];
      sub = [NSArray mulleArrayWithArray:a range:NSMakeRange( 1, 2)];
      mulle_printf( "mulleArrayWithArray:range: count: %lu\n", (unsigned long)[sub count]);
      mulle_printf( "mulleArrayWithArray:range:[0]: %s\n", [[sub objectAtIndex:0] UTF8String]);

      // mulleArrayWithArray:range: with zero length
      sub = [NSArray mulleArrayWithArray:a range:NSMakeRange( 0, 0)];
      mulle_printf( "mulleArrayWithArray:range: zero len: %lu\n", (unsigned long)[sub count]);

      // initWithArray:copyItems:YES
      a = [NSArray arrayWithObjects:[Str str:"p"], [Str str:"q"], nil];
      b = [[[NSArray alloc] initWithArray:a copyItems:YES] autorelease];
      mulle_printf( "initWithArray:copyItems: count: %lu\n", (unsigned long)[b count]);
      mulle_printf( "initWithArray:copyItems:[0]: %s\n", [[b objectAtIndex:0] UTF8String]);

      // initWithArray:copyItems: with empty source
      b = [[[NSArray alloc] initWithArray:empty copyItems:YES] autorelease];
      mulle_printf( "initWithArray:copyItems: empty: %lu\n", (unsigned long)[b count]);

      // arrayWithObject:
      a = [NSArray arrayWithObject:[Str str:"solo"]];
      mulle_printf( "arrayWithObject count: %lu\n", (unsigned long)[a count]);
      mulle_printf( "arrayWithObject[0]: %s\n", [[a objectAtIndex:0] UTF8String]);

      // arrayWithObject: nil → empty
      a = [NSArray arrayWithObject:nil];
      mulle_printf( "arrayWithObject nil: %lu\n", (unsigned long)[a count]);

      // arrayWithObjects:count:
      objs[0] = [Str str:"one"];
      objs[1] = [Str str:"two"];
      objs[2] = [Str str:"three"];
      a = [NSArray arrayWithObjects:objs count:3];
      mulle_printf( "arrayWithObjects:count: count: %lu\n", (unsigned long)[a count]);
      mulle_printf( "arrayWithObjects:count:[1]: %s\n", [[a objectAtIndex:1] UTF8String]);

      // sortedArrayUsingFunction:
      a = [NSArray arrayWithObjects:[Str str:"cherry"], [Str str:"apple"], [Str str:"banana"], nil];
      b = [a sortedArrayUsingFunction:reverseCompare context:NULL];
      mulle_printf( "sortedByFunction[0]: %s\n", [[b objectAtIndex:0] UTF8String]);
      mulle_printf( "sortedByFunction[2]: %s\n", [[b objectAtIndex:2] UTF8String]);

      // sortedArrayUsingSelector:
      b = [a sortedArrayUsingSelector:@selector( compare:)];
      mulle_printf( "sortedBySelector[0]: %s\n", [[b objectAtIndex:0] UTF8String]);
      mulle_printf( "sortedBySelector[2]: %s\n", [[b objectAtIndex:2] UTF8String]);

      // sortedArrayUsingSelector: on empty array
      b = [empty sortedArrayUsingSelector:@selector( compare:)];
      mulle_printf( "sortedBySelector empty: %lu\n", (unsigned long)[b count]);

      // arrayByAddingObjectsFromArray: with both empty → covers mulleInitWithArray:andArray: empty case
      b = [empty arrayByAddingObjectsFromArray:empty];
      mulle_printf( "arrayByAddingFromArray both-empty: %lu\n", (unsigned long)[b count]);

      // arrayByAddingObject: nil on empty → covers mulleInitWithArray:andObject: empty case
      b = [empty arrayByAddingObject:nil];
      mulle_printf( "arrayByAddingObject nil-on-empty: %lu\n", (unsigned long)[b count]);

      // firstObjectCommonWithArray:
      a = [NSArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      b = [NSArray arrayWithObjects:[Str str:"x"], [Str str:"b"], [Str str:"y"], nil];
      id common = [a firstObjectCommonWithArray:b];
      mulle_printf( "firstObjectCommon: %s\n", [(Str *) common UTF8String]);

      // firstObjectCommonWithArray: nil
      mulle_printf( "firstObjectCommon nil: %s\n",
         [a firstObjectCommonWithArray:nil] == nil ? "nil" : "not-nil");

      // indexOfObject:inRange:
      a = [NSArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], [Str str:"b"], nil];
      idx = [a indexOfObject:[Str str:"b"] inRange:NSMakeRange( 2, 2)];
      mulle_printf( "indexOfObject:inRange: found: %lu\n", (unsigned long)idx);

      idx = [a indexOfObject:[Str str:"a"] inRange:NSMakeRange( 1, 3)];
      mulle_printf( "indexOfObject:inRange: not found: %s\n", idx == NSNotFound ? "yes" : "no");

      // mulleContainsObjectIdenticalTo:
      Str *ref = [Str str:"ref"];
      a = [NSArray arrayWithObjects:[Str str:"x"], ref, [Str str:"y"], nil];
      mulle_printf( "mulleContainsObjectIdenticalTo: yes: %s\n",
         [a mulleContainsObjectIdenticalTo:ref] ? "yes" : "no");
      mulle_printf( "mulleContainsObjectIdenticalTo: no: %s\n",
         [a mulleContainsObjectIdenticalTo:[Str str:"ref"]] ? "yes" : "no");

      // indexOfObjectIdenticalTo:
      idx = [a indexOfObjectIdenticalTo:ref];
      mulle_printf( "indexOfObjectIdenticalTo: idx: %lu\n", (unsigned long)idx);

      // indexOfObjectIdenticalTo:inRange:
      idx = [a indexOfObjectIdenticalTo:ref inRange:NSMakeRange( 0, 2)];
      mulle_printf( "indexOfObjectIdenticalTo:inRange: found: %lu\n", (unsigned long)idx);

      idx = [a indexOfObjectIdenticalTo:ref inRange:NSMakeRange( 2, 1)];
      mulle_printf( "indexOfObjectIdenticalTo:inRange: not-found: %s\n",
         idx == NSNotFound ? "yes" : "no");

      // mulleForEachObjectCallFunction: - MullePreemptIfMatches (stops at first match)
      a = [NSArray arrayWithObjects:[Str str:"bar"], [Str str:"foo"], [Str str:"baz"], nil];
      id found = [a mulleForEachObjectCallFunction:matchFoo
                                          argument:NULL
                                           preempt:MullePreemptIfMatches];
      mulle_printf( "forEach preemptIfMatches: %s\n", [(Str *) found UTF8String]);

      // mulleForEachObjectCallFunction: - MullePreemptIfNotMatches
      found = [a mulleForEachObjectCallFunction:matchFoo
                                       argument:NULL
                                        preempt:MullePreemptIfNotMatches];
      mulle_printf( "forEach preemptIfNotMatches: %s\n", [(Str *) found UTF8String]);

      // mulleForEachObjectCallFunction: - MullePreemptNever (visit all)
      found = [a mulleForEachObjectCallFunction:matchFoo
                                       argument:NULL
                                        preempt:MullePreemptNever];
      mulle_printf( "forEach preemptNever: %s\n", found == nil ? "nil" : "not-nil");

      // containsObject:inRange:
      a = [NSArray arrayWithObjects:[Str str:"a"], [Str str:"b"], [Str str:"c"], nil];
      mulle_printf( "containsObject:inRange: yes: %s\n",
         [a containsObject:[Str str:"b"] inRange:NSMakeRange( 0, 3)] ? "yes" : "no");
      mulle_printf( "containsObject:inRange: no: %s\n",
         [a containsObject:[Str str:"b"] inRange:NSMakeRange( 2, 1)] ? "yes" : "no");

      // getObjects: (no range)
      a = [NSArray arrayWithObjects:[Str str:"u"], [Str str:"v"], [Str str:"w"], nil];
      [a getObjects:buf];
      mulle_printf( "getObjects: [0]: %s\n", [(Str *) buf[0] UTF8String]);
      mulle_printf( "getObjects: [2]: %s\n", [(Str *) buf[2] UTF8String]);
   }
   return( 0);
}

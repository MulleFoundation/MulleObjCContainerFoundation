#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

// Plain NSObject subclass — inherits pointer-based -hash and -isEqual:
@interface Token : NSObject
@end
@implementation Token
@end


int   main( void)
{
   NSMapTable      *table;
   NSMapTable      *copy;
   NSMapEnumerator rover;
   void            *key;
   void            *value;
   NSUInteger      count;
   id  k1, k2, k3, k4, k5;
   id  v1, v2, v3, v4, v5;

   k1 = [[[Token alloc] init] autorelease];
   k2 = [[[Token alloc] init] autorelease];
   k3 = [[[Token alloc] init] autorelease];
   k4 = [[[Token alloc] init] autorelease];
   k5 = [[[Token alloc] init] autorelease];
   v1 = [[[Token alloc] init] autorelease];
   v2 = [[[Token alloc] init] autorelease];
   v3 = [[[Token alloc] init] autorelease];
   v4 = [[[Token alloc] init] autorelease];
   v5 = [[[Token alloc] init] autorelease];

   table = MulleObjCMapTableCreate( NSNonRetainedObjectMapKeyCallBacks,
                                    NSNonRetainedObjectMapValueCallBacks,
                                    4);
   mulle_printf( "created: %s\n", table ? "yes" : "no");
   mulle_printf( "count: %lu\n", (unsigned long) NSCountMapTable( table));

   MulleObjCMapTableInsert( table, k1, v1);
   MulleObjCMapTableInsert( table, k2, v2);
   MulleObjCMapTableInsert( table, k3, v3);
   mulle_printf( "count after 3 inserts: %lu\n", (unsigned long) NSCountMapTable( table));

   value = NSMapGet( table, k2);
   mulle_printf( "get k2: %s\n", value == v2 ? "found" : "wrong");

   value = NSMapGet( table, k5);
   mulle_printf( "get missing: %s\n", value ? "found" : "nil");

   void *existing = MulleObjCMapTableInsertIfAbsent( table, k2, v5);
   mulle_printf( "insertIfAbsent existing: %s\n", existing == v2 ? "returned old" : "wrong");

   existing = MulleObjCMapTableInsertIfAbsent( table, k4, v4);
   mulle_printf( "insertIfAbsent new: %s\n", existing ? "returned old" : "inserted");
   mulle_printf( "count after insertIfAbsent: %lu\n", (unsigned long) NSCountMapTable( table));

   MulleObjCMapTableInsertKnownAbsent( table, k5, v5);
   mulle_printf( "count after insertKnownAbsent: %lu\n", (unsigned long) NSCountMapTable( table));

   NSMapRemove( table, k3);
   mulle_printf( "count after remove: %lu\n", (unsigned long) NSCountMapTable( table));

   count = 0;
   rover = NSEnumerateMapTable( table);
   while( NSNextMapEnumeratorPair( &rover, &key, &value))
      count++;
   NSEndMapTableEnumeration( &rover);
   mulle_printf( "enumerated %lu entries\n", (unsigned long) count);

   copy = MulleObjCMapTableCopy( table);
   mulle_printf( "copy count: %lu\n", (unsigned long) NSCountMapTable( copy));

   MulleObjCMapTableReset( table);
   mulle_printf( "count after reset: %lu\n", (unsigned long) NSCountMapTable( table));

   MulleObjCMapTableFree( copy);
   MulleObjCMapTableFree( table);
   mulle_printf( "done\n");

   return( 0);
}

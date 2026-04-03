#import <MulleObjCContainerFoundation/MulleObjCContainerFoundation.h>

// Plain NSObject subclass — inherits pointer-based -hash and -isEqual:
@interface HashToken : NSObject
@end
@implementation HashToken
@end


int   main( void)
{
   NSHashTable      *table;
   NSHashTable      *copy;
   NSHashEnumerator rover;
   void             *item;
   NSUInteger       count;
   id  p1, p2, p3, p4, p5;

   p1 = [[[HashToken alloc] init] autorelease];
   p2 = [[[HashToken alloc] init] autorelease];
   p3 = [[[HashToken alloc] init] autorelease];
   p4 = [[[HashToken alloc] init] autorelease];
   p5 = [[[HashToken alloc] init] autorelease];

   // NSNonRetainedObjectHashCallBacks: ObjC -hash/-isEqual:, no retain/release
   table = MulleObjCHashTableCreate( NSNonRetainedObjectHashCallBacks, 4);
   mulle_printf( "created: %s\n", table ? "yes" : "no");
   mulle_printf( "count: %lu\n", (unsigned long) NSCountHashTable( table));

   MulleObjCHashTableInsert( table, p1);
   MulleObjCHashTableInsert( table, p2);
   MulleObjCHashTableInsert( table, p3);
   mulle_printf( "count after 3 inserts: %lu\n", (unsigned long) NSCountHashTable( table));

   item = NSHashGet( table, p2);
   mulle_printf( "get p2: %s\n", item == p2 ? "found" : "wrong");

   item = NSHashGet( table, p5);
   mulle_printf( "get missing: %s\n", item ? "found" : "nil");

   void *existing = MulleObjCHashTableInsertIfAbsent( table, p2);
   mulle_printf( "insertIfAbsent existing: %s\n", existing == p2 ? "returned old" : "wrong");

   existing = MulleObjCHashTableInsertIfAbsent( table, p4);
   mulle_printf( "insertIfAbsent new: %s\n", existing ? "returned old" : "inserted");
   mulle_printf( "count after insertIfAbsent: %lu\n", (unsigned long) NSCountHashTable( table));

   MulleObjCHashTableInsertKnownAbsent( table, p5);
   mulle_printf( "count after insertKnownAbsent: %lu\n", (unsigned long) NSCountHashTable( table));

   NSHashRemove( table, p3);
   mulle_printf( "count after remove: %lu\n", (unsigned long) NSCountHashTable( table));

   count = 0;
   rover = NSEnumerateHashTable( table);
   while( (item = NSNextHashEnumeratorItem( &rover)) != NULL)
      count++;
   NSEndHashTableEnumeration( &rover);
   mulle_printf( "enumerated %lu entries\n", (unsigned long) count);

   copy = MulleObjCHashTableCopy( table);
   mulle_printf( "copy count: %lu\n", (unsigned long) NSCountHashTable( copy));

   NSResetHashTable( table);
   mulle_printf( "count after reset: %lu\n", (unsigned long) NSCountHashTable( table));

   MulleObjCHashTableFree( copy);
   MulleObjCHashTableFree( table);
   mulle_printf( "done\n");

   return( 0);
}

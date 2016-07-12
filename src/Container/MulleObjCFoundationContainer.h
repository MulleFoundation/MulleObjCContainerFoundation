//
//  MulleObjCContainer.h
//  MulleObjCFoundation
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

// export everything with NS

#import "NSArray.h"
#import "NSDictionary.h"
#import "NSEnumerator.h"
#import "NSMutableArray.h"
#import "NSMutableDictionary.h"
#import "NSMutableSet.h"
#import "NSSet.h"

#import "NSArray+NSString.h"
#import "NSEnumerator+NSArray.h"
#import "NSDictionary+NSArray.h"
#import "NSHashTable+NSArray+NSString.h"
#import "NSMapTable+NSArray+NSString.h"
#import "NSMutableSet+NSArray.h"
#import "NSSet+NSArray.h"
#import "NSThread+NSMutableDictionary.h"

// export everything with MulleObjC
#import "MulleObjCContainerCallback.h"

// export nothing with _MulleObjC


// export everything with ns_

#import "ns_map_table.h"
#import "ns_hash_table.h"


#if MULLE_CONTAINER_VERSION < ((0 << 20) | (8 << 8) | 0)
# error "mulle_allocator is too old"
#endif


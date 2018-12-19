//
//  MulleObjCFoundationContainer.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

// export everything with NS
#import "NSArray.h"
#import "NSDictionary.h"
#import "NSEnumerator.h"
#import "NSMutableArray.h"
#import "NSMutableDictionary.h"
#import "NSMutableSet.h"
#import "NSSet.h"
#import "NSSortDescriptor.h"

#import "NSArray+NSString.h"
#import "NSArray+NSSortDescriptor.h"
#import "NSEnumerator+NSArray.h"
#import "NSDictionary+NSArray.h"
#import "NSHashTable+NSArray+NSString.h"
#import "NSMapTable+NSArray+NSString.h"
#import "NSMutableSet+NSArray.h"
#import "NSSet+NSArray.h"
#import "NSThread+NSMutableDictionary.h"

// export nothing with _MulleObjC


// export everything with ns_

#import "ns-map-table.h"
#import "ns-hash-table.h"


#if MULLE_CONTAINER_VERSION < ((0 << 20) | (8 << 8) | 0)
# error "mulle_allocator is too old"
#endif

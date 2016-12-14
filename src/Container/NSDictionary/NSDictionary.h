//
//  NSDictionary.h
//  MulleObjCFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import <MulleObjC/MulleObjC.h>


@class NSEnumerator;


@interface NSDictionary : NSObject < NSCopying, NSCoding, MulleObjCClassCluster>

+ (id) dictionary;
+ (id) dictionaryWithDictionary:(NSDictionary *) dictionary;
+ (id) dictionaryWithObject:(id) anObject 
                     forKey:(id) aKey;
+ (id) dictionaryWithObjects:(id *) objects 
                     forKeys:(id *) keys 
                       count:(NSUInteger) count;
+ (id) dictionaryWithObjectsAndKeys:(id) firstObject , ...;

- (id) initWithDictionary:(NSDictionary *) otherDictionary;
- (id) initWithDictionary:(NSDictionary *) otherDictionary 
                copyItems:(BOOL) flag;
- (id) initWithObjects:(id *) objects 
               forKeys:(id *) keys 
                 count:(NSUInteger) count;
- (id) initWithObjectsAndKeys:(id)firstObject , ...;
- (id) initWithObject:(id) object
            arguments:(mulle_vararg_list) args;


- (BOOL) isEqualToDictionary:(NSDictionary *) other;

@end



@interface NSDictionary( Subclasses)

- (NSUInteger) count;
- (void) getObjects:(id *) objects 
            andKeys:(id *) keys;

- (id) objectForKey:(id) key;
- (NSEnumerator *) keyEnumerator;
- (NSEnumerator *) objectEnumerator;

@end

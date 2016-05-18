/*
 *  MulleEOFoundation - Base Functionality of MulleEOF (Project Titmouse) 
 *                      Part of the Mulle EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, Mulle kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSArray+NSSortDescriptor.h,v b9a3127cf1df 2010/08/11 16:35:38 nat $
 *
 *  $Log$
 */
#import "NSArray.h"
#import "NSMutableArray.h"


@interface NSArray ( NSSortDescriptor)

- (NSArray *) sortedArrayUsingDescriptors:(NSArray *) orderings;

@end


@interface NSMutableArray ( NSSortDescriptor)

- (void) sortUsingDescriptors:(NSArray *) orderings;

@end

//
//  SAPIMetadataResult.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIMetadataResult.h"

@implementation SAPIMetadataResult

@synthesize categories;
@synthesize categoryGroups;

- (void)dealloc
{
    [categoryGroups release];
    [categories release];
    
    [super dealloc];
}

- (NSArray *)groups
{
    return self.categoryGroups;
}

- (void)setGroups:(NSArray *)groups
{
    self.categoryGroups = groups;
}

@end

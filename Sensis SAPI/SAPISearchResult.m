//
//  SAPISearchResult.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPISearchResult.h"

@implementation SAPISearchResult

@synthesize results;
@synthesize count;
@synthesize totalResults;
@synthesize currentPage;
@synthesize totalPages;
@synthesize executedQuery;
@synthesize originalQuery;
@synthesize date;

- (void)dealloc
{
    [executedQuery release];
    [originalQuery release];
    [date release];

    [super dealloc];
}

@end

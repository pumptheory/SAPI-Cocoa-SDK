//
//  SAPISearch.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPISearch.h"
#import "SAPIPrivate.h"

@implementation SAPISearch

@synthesize query=_query;
@synthesize location=_location;

- (void)dealloc
{
    [_query release], _query = nil;
    [_location release], _location = nil;
    
    [super dealloc];
}

- (NSString *)endpoint
{
    return @"search";
}

- (NSArray *)queryKeys
{
    return [NSArray arrayWithObjects:
            @"query",
            @"location", 
            nil];
}

@end

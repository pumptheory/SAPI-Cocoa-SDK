//
//  SAPISearch.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPISearch.h"

@implementation SAPISearch

@synthesize query=_query;
@synthesize location=_location;

- (SAPISearchResult *)performQueryWithError:(SAPIError **)error
{
    
}

- (void)performQueryAsyncWithCallback:(void (^)(SAPISearchResult * result, SAPIError * error))callbackBlock
{
    
}


@end

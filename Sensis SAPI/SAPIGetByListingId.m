//
//  SAPIGetListing.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIGetByListingId.h"

@implementation SAPIGetByListingId

@synthesize query;

- (void)dealloc
{
    [query release];
    
    [super dealloc];
}

- (NSString *)endpoint
{
    return @"getByListingId";
}

- (NSDictionary *)queryKeys
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"query", @"query",            
            nil];
}

- (NSString *)businessId
{
    return self.query;
}

- (void)setBusinessId:(NSString *)businessId
{
    self.query = businessId;
}

@end

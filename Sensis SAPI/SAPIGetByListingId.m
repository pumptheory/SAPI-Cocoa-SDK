//
//  SAPIGetListing.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIGetByListingId.h"
#import "SAPIPrivate.h"

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

- (Class)resultClass
{
    return [SAPISearchResult class];
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

- (SAPISearchResult *)performQueryWithError:(SAPIError **)error
{
    return (SAPISearchResult *)[self _performQueryWithError:error];
}

- (void)performQueryAsyncSuccess:(void (^)(SAPISearchResult * result))successBlock
                         failure:(void (^)(SAPIError * error))failureBlock
{
    return [self _performQueryAsyncSuccess:(void (^)(SAPIResult * result))successBlock failure:failureBlock];
}

@end

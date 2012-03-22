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

@synthesize query;
@synthesize location;
@synthesize page;
@synthesize rows;
@synthesize sortBy;
@synthesize sensitiveCategories;
@synthesize categoryIdArray;
@synthesize postcodeArray;
@synthesize radius;
@synthesize locationTiers;
@synthesize suburbArray;
@synthesize stateArray;
@synthesize boundingBox;
@synthesize contentArray;
@synthesize productKeywordArray;

- (void)dealloc
{
    [query release];
    [location release];
    [sortBy release];
    [categoryIdArray release];
    [postcodeArray release];
    [suburbArray release];
    [stateArray release];
    [boundingBox release];
    [contentArray release];
    [productKeywordArray release];
    
    [super dealloc];
}

- (NSString *)endpoint
{
    return @"search";
}

- (Class)resultClass
{
    return [SAPISearchResult class];
}

- (NSDictionary *)queryKeys
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"query", @"query",
            @"location", @"location",
            @"page", @"page",
            @"rows", @"rows",
            @"sortBy", @"sortBy",
            @"sensitiveCategories", @"sensitiveCategories",
            @"radius", @"radius",
            @"locationTiers", @"locationTiers",
            @"boundingBox", @"boundingBox",
            
            @"categoryId", @"categoryIdArray",
            @"postcode", @"postcodeArray",
            @"suburb", @"suburbArray",
            @"state", @"stateArray",
            @"content", @"contentArray",
            @"productKeyword", @"productKeywordArray",

            nil];
}

- (id)queryValueForKey:(NSString *)key
{
    // omit unset scalar values from query string
    
    if ([key isEqualToString:@"radius"] && self.radius == 0)
        return nil;
    else if ([key isEqualToString:@"page"] && self.page == 0)
        return nil;
    else if ([key isEqualToString:@"rows"] && self.rows == 0)
        return nil;
    else if ([key isEqualToString:@"sensitiveCategories"] && self.sensitiveCategories == NO)
        return nil;
    else if ([key isEqualToString:@"locationTiers"] && self.locationTiers == 0)
        return nil;
    
    return [super queryValueForKey:key];
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

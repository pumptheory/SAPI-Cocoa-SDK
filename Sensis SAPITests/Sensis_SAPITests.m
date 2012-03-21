//
//  Sensis_SAPITests.m
//  Sensis SAPITests
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "Sensis_SAPITests.h"

#import "SAPI.h"
#import "SAPIAccountKey.h"
#import "SAPISearch.h"

@implementation Sensis_SAPITests

- (void)setUp
{
    [super setUp];
    
    [SAPI setKey:SAPI_KEY];
    [SAPI setEnvironment:SAPI_ENVIRONMENT];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSearch
{
    SAPISearch * searchQuery = [[SAPISearch alloc] init];
    searchQuery.query = @"Apple";
    SAPIError * error = nil;
    SAPIResult * res = [searchQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"Simple Search query returned no results (%@)", error]);
    
    NSLog(@"testSearchResults: %@", res.results);
}

@end

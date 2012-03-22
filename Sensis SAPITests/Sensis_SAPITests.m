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
    
    // we need to stay slow so the tests can succeed in SAPI test environment due to rate limit
    sleep(1);
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

NSUInteger appleResultCount = 0;

- (void)testASearch
{ 
    SAPISearch * searchQuery = [[SAPISearch alloc] init];
    searchQuery.query = @"Apple";
    SAPIError * error = nil;
    SAPIResult * res = [searchQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"Simple Search query returned no results (%@)", error]);
    STAssertTrue([res.results isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertFalse([res.results count] == 0, @"We expect a search query of 'Apple' to have > 0 results");
    
    appleResultCount = res.totalResults;
}

- (void)testBSearchStateFilter
{
    SAPISearch * searchQuery = [[SAPISearch alloc] init];
    searchQuery.query = @"Apple";
    searchQuery.stateArray = [NSArray arrayWithObject:@"NSW"];
    SAPIError * error = nil;
    SAPIResult * res = [searchQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"Simple Search query returned no results (%@)", error]);
    STAssertTrue([res.results isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertFalse([res.results count] == 0, @"We expect a search query of 'Apple' to have > 0 results");

    STAssertTrue(res.totalResults < appleResultCount, @"doing the same search with a state filter should have fewer results");
    
    appleResultCount = res.totalResults;
}

- (void)testCSearchMultipleStateFilter
{
    SAPISearch * searchQuery = [[SAPISearch alloc] init];
    searchQuery.query = @"Apple";
    searchQuery.stateArray = [NSArray arrayWithObjects:@"NSW", @"VIC", nil];
    SAPIError * error = nil;
    SAPIResult * res = [searchQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"Simple Search query returned no results (%@)", error]);
    STAssertTrue([res.results isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertFalse([res.results count] == 0, @"We expect a search query of 'Apple' to have > 0 results");
    
    STAssertTrue(res.totalResults > appleResultCount, @"doing the same search with a multiple state filter should have more results than with one state");
}

- (void)testValidationError
{
    SAPISearch * searchQuery = [[SAPISearch alloc] init];
    SAPIError * error = nil;
    SAPIResult * res = [searchQuery performQueryWithError:&error];
    
    STAssertNil(res, @"Invalid search returned a result");
    STAssertNotNil(error, @"Invalid search did not return an error");
    STAssertEquals(error.code, SAPIErrorValidationError, @"Invalid search did not return the SAPIErrorValidationError error code");
    STAssertEquals(error.httpStatusCode , 200, @"Invalid search term should return the http status code 200");
}

- (void)testPermissionsError
{
    [SAPI setKey:@"foo"];
    SAPISearch * searchQuery = [[SAPISearch alloc] init];
    searchQuery.query = @"Apple";
    SAPIError * error = nil;
    SAPIResult * res = [searchQuery performQueryWithError:&error];
    
    STAssertNil(res, @"Bad permissions query returned a result");
    STAssertNotNil(error, @"Bad permissions query did not return an error");
    STAssertEquals(error.code, SAPIErrorForbidden, @"Bad permissions query did not return the SAPIErrorForbidden error code");
    STAssertEquals(error.httpStatusCode , 403, @"Bad permissions query should return the http status code 200");
}


- (void)testResults
{
    SAPISearch * searchQuery = [[SAPISearch alloc] init];
    searchQuery.query = @"Apple";
    SAPIError * error = nil;
    SAPIResult * res = [searchQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"Simple Search query returned no results (%@)", error]);
    STAssertTrue([res.results isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertFalse([res.results count] == 0, @"We expect a search query of 'Apple' to have > 0 results");
    
    // we know that a query for "Apple" will return plenty of results - do some basic sanity checks on the first result
    
    NSDictionary * firstResult = [res.results objectAtIndex:0];
    STAssertTrue([firstResult isKindOfClass:[NSDictionary class]], @"first result entry is not a dictionary");
    STAssertTrue([[firstResult objectForKey:@"categories"] isKindOfClass:[NSArray class]], @"categories key is not a dictionary");
    STAssertTrue([[firstResult objectForKey:@"detailsLink"] isKindOfClass:[NSString class]], @"detailsLink key is not a string");
    STAssertTrue([[firstResult objectForKey:@"detailsLink"] hasPrefix:@"http"], @"detailsLink key does not start with http");
}


@end

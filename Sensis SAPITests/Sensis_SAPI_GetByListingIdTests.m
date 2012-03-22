//
//  Sensis_SAPI_GetByListingIdTests.m
//  Sensis SAPITests
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "Sensis_SAPI_GetByListingIdTests.h"

#import "SAPI.h"
#import "SAPIAccountKey.h"
#import "SAPIGetByListingId.h"
#import "SAPISearch.h"

@implementation Sensis_SAPI_GetByListingIdTests

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

- (void)testGetByListingIdValidationError
{
    SAPIGetByListingId * getByListingIdQuery = [[SAPIGetByListingId alloc] init];
    SAPIError * error = nil;
    SAPIResult * res = [getByListingIdQuery performQueryWithError:&error];
    
    STAssertNil(res, @"Invalid search returned a result");
    STAssertNotNil(error, @"Invalid search did not return an error");
    STAssertEquals(error.code, SAPIErrorValidationError, @"Invalid search did not return the SAPIErrorValidationError error code");
    STAssertEquals(error.httpStatusCode , 200, @"Invalid search term should return the http status code 200");
    
    [getByListingIdQuery release];
}

- (void)testGetByListingIdEmptyResultTest
{
    SAPIGetByListingId * getByListingIdQuery = [[SAPIGetByListingId alloc] init];
    getByListingIdQuery.businessId = @"0";
    SAPIError * error = nil;
    SAPIResult * res = [getByListingIdQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"Empty Listing Search query returned nil result (%@)", error]);
    STAssertTrue([res.results isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertTrue([res.results count] == 0, @"We expect a businessId search query of '0' to have 0 results");
    
    [getByListingIdQuery release];
}

NSString * businessId = nil;

- (void)testAGetTheBusinessId
{
    // first we need to get a businessId
    
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
    STAssertTrue([[firstResult objectForKey:@"id"] isKindOfClass:[NSString class]], @"detailsLink key is not a string");

    businessId = [firstResult objectForKey:@"id"];
}

- (void)testBGetTheDetailResult
{
    SAPIGetByListingId * getByListingIdQuery = [[SAPIGetByListingId alloc] init];
    getByListingIdQuery.businessId = businessId;
    SAPIError * error = nil;
    SAPIResult * res = [getByListingIdQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"Detail Listing Search query returned nil result (%@)", error]);
    STAssertTrue([res.results isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertTrue([res.results count] == 1, @"We expect exactly 1 result from a valid getByListingId search");
    
    [getByListingIdQuery release];
}

- (void)testCGetTheDetailResultAndInspect
{
    SAPIGetByListingId * getByListingIdQuery = [[SAPIGetByListingId alloc] init];
    getByListingIdQuery.businessId = businessId;
    SAPIError * error = nil;
    SAPIResult * res = [getByListingIdQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"Detail Listing Search query returned nil result (%@)", error]);
    STAssertTrue([res.results isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertTrue([res.results count] == 1, @"We expect exactly 1 result from a valid getByListingId search");
    
    NSDictionary * listing = [res.results objectAtIndex:0];
    STAssertTrue([listing isKindOfClass:[NSDictionary class]], @"first result entry is not a dictionary");
    STAssertTrue([[listing objectForKey:@"categories"] isKindOfClass:[NSArray class]], @"categories key is not a dictionary");
    STAssertTrue([[listing objectForKey:@"detailsLink"] isKindOfClass:[NSString class]], @"detailsLink key is not a string");
    STAssertTrue([[listing objectForKey:@"detailsLink"] hasPrefix:@"http"], @"detailsLink key does not start with http");
    
    [getByListingIdQuery release];
}


@end

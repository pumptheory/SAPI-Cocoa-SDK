//
//  Sensis_SAPI_ReportTests.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "Sensis_SAPI_ReportTests.h"

#import "SAPI.h"
#import "SAPITestAccountKey.h"
#import "SAPIReport.h"
#import "SAPISearch.h"

@implementation Sensis_SAPI_ReportTests

- (void)setUp
{
    [super setUp];
    
    [SAPI setKey:SAPI_TEST_KEY];
    [SAPI setEnvironment:SAPI_TEST_ENVIRONMENT];
    
    // we need to stay slow so the tests can succeed in SAPI test environment due to rate limit
    sleep(1);
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testValidationError
{
    SAPIReport * reportQuery = [[SAPIReport alloc] init];
    reportQuery.eventName = @"appearance";
    SAPIError * error = nil;
    SAPIReportResult * res = [reportQuery performQueryWithError:&error];
    
    STAssertNil(res, @"Invalid report returned a result");
    STAssertNotNil(error, @"Invalid report did not return an error");
    STAssertEquals(error.code, SAPIErrorValidationError, @"Invalid report did not return the SAPIErrorValidationError error code");
    STAssertEquals(error.httpStatusCode , 200, @"Invalid report should return the http status code 200");
    
    [reportQuery release];
}

- (void)testSuccess
{
    // get a reportingId from a search
    
    SAPISearch * searchQuery = [[SAPISearch alloc] init];
    searchQuery.query = @"Apple";
    SAPIError * error = nil;
    SAPISearchResult * searchRes = [searchQuery performQueryWithError:&error];
    
    STAssertNotNil(searchRes, [NSString stringWithFormat:@"Simple Search query returned no results (%@)", error]);
    STAssertTrue([searchRes.results isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertFalse([searchRes.results count] == 0, @"We expect a search query of 'Apple' to have > 0 results");
    
    // we know that a query for "Apple" will return plenty of results - do some basic sanity checks on the first result
    
    NSDictionary * firstResult = [searchRes.results objectAtIndex:0];
    STAssertTrue([firstResult isKindOfClass:[NSDictionary class]], @"first result entry is not a dictionary");
    
    NSString * reportingId = [firstResult objectForKey:@"reportingId"];
    STAssertTrue([reportingId isKindOfClass:[NSString class]], @"reportingId is not a string");
    
    [searchQuery release];
    
    // do the actual report
    
    SAPIReport * reportQuery = [[SAPIReport alloc] init];
    reportQuery.eventName = @"appearance";
    reportQuery.reportingIdArray = [NSArray arrayWithObject:reportingId];
    reportQuery.userIp = @"10.0.0.1"; // need to get the user's external IP in production
    
    error = nil;
    SAPIReportResult * reportRes = [reportQuery performQueryWithError:&error];

    STAssertEquals(reportRes.code, SAPIResultSuccess, @"Report returned Success code");
    STAssertNotNil(reportRes, [NSString stringWithFormat:@"Report returned nil result (%@)", error]);
    STAssertTrue([reportRes.date isKindOfClass:[NSDate class]], @"Returned result.date is not valid");
    STAssertNil(reportRes.validationWarnings, @"ValidationWarnings should be nil for successful report");
    
    [reportQuery release];
}

- (void)testPartialSuccess
{
    // get a reportingId from a search
    
    SAPISearch * searchQuery = [[SAPISearch alloc] init];
    searchQuery.query = @"Apple";
    SAPIError * error = nil;
    SAPISearchResult * searchRes = [searchQuery performQueryWithError:&error];
    
    STAssertNotNil(searchRes, [NSString stringWithFormat:@"Simple Search query returned no results (%@)", error]);
    STAssertTrue([searchRes.results isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertFalse([searchRes.results count] == 0, @"We expect a search query of 'Apple' to have > 0 results");
    
    // we know that a query for "Apple" will return plenty of results - do some basic sanity checks on the first result
    
    NSDictionary * firstResult = [searchRes.results objectAtIndex:0];
    STAssertTrue([firstResult isKindOfClass:[NSDictionary class]], @"first result entry is not a dictionary");
    
    NSString * reportingId = [firstResult objectForKey:@"reportingId"];
    STAssertTrue([reportingId isKindOfClass:[NSString class]], @"reportingId is not a string");
    
    [searchQuery release];
    
    // do the actual report - with the real id and a fake id that will fail
    
    SAPIReport * reportQuery = [[SAPIReport alloc] init];
    reportQuery.eventName = @"appearance";
    reportQuery.reportingIdArray = [NSArray arrayWithObjects:reportingId, @"foo", nil];
    reportQuery.userIp = @"10.0.0.1"; // need to get the user's external IP in production
        
    error = nil;
    SAPIReportResult * reportRes = [reportQuery performQueryWithError:&error];
    
    STAssertEquals(reportRes.code, SAPIResultQueryModified, @"Report returned SAPIResultQueryModified code");
    STAssertNotNil(reportRes, [NSString stringWithFormat:@"Report returned nil result (%@)", error]);
    STAssertTrue([reportRes.date isKindOfClass:[NSDate class]], @"Returned result.date is not valid");
    STAssertTrue([reportRes.validationWarnings isKindOfClass:[NSArray class]], @"ValidationWarnings should be an NSArray for a partially successful report");
    STAssertTrue([reportRes.validationWarnings count] == 1, @"ValidationWarnings should have one entry for our partially successful report");
    
    [reportQuery release];
}


@end

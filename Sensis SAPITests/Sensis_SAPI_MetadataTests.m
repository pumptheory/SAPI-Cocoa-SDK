//
//  Sensis_SAPI_MetadataTests.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "Sensis_SAPI_MetadataTests.h"

#import "SAPI.h"
#import "SAPIAccountKey.h"
#import "SAPIMetadata.h"

@implementation Sensis_SAPI_MetadataTests

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

- (void)testCategories
{ 
    SAPIMetadata * metadataQuery = [[SAPIMetadata alloc] init];
    metadataQuery.dataType = SAPIMetadataCategoriesKey;
    SAPIError * error = nil;
    SAPIMetadataResult * res = [metadataQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"Categories query returned no results (%@)", error]);
    STAssertTrue([res.categories isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertFalse([res.categories count] == 0, @"We expect a categories query to have > 0 results");
    
    NSDictionary * firstResult = [res.categories objectAtIndex:0];
    STAssertTrue([firstResult isKindOfClass:[NSDictionary class]], @"first result entry is not a dictionary");
    STAssertTrue([[firstResult objectForKey:@"id"] isKindOfClass:[NSNumber class]], @"id key is not a number");
    STAssertTrue([[firstResult objectForKey:@"name"] isKindOfClass:[NSString class]], @"id key is not a string");
    
    [metadataQuery release];
}

- (void)testCategoryGroups
{ 
    SAPIMetadata * metadataQuery = [[SAPIMetadata alloc] init];
    metadataQuery.dataType = SAPIMetadataCategoryGroupsKey;
    SAPIError * error = nil;
    SAPIMetadataResult * res = [metadataQuery performQueryWithError:&error];
    
    STAssertNotNil(res, [NSString stringWithFormat:@"CategoryGroups query returned no results (%@)", error]);
    STAssertTrue([res.categoryGroups isKindOfClass:[NSArray class]], @"Returned results are not NSArray");
    STAssertFalse([res.categoryGroups count] == 0, @"We expect a categoryGroups query to have > 0 results");
    
    [metadataQuery release];
}


@end

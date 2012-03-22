//
//  SAPISearch.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIEndpoint.h"
#import "SAPIResult.h"
#import "SAPIError.h"

@interface SAPISearch : SAPIEndpoint

// See also the endpoint reference for more detail: http://developers.sensis.com.au/docs/endpoint_reference/Search

@property (copy) NSString * query;            // What to search for (required unless location is given)
@property (copy) NSString * location;         // Location to search in (required unless query is given)
@property NSUInteger page;                    // Page number to return (defaults to first page)
@property NSUInteger rows;                    // Number of listings to return per page (currently default is 20, max 50)
@property (copy) NSString * sortBy;           // Listing sort order
@property BOOL sensitiveCategories;           // Filtering potentially unsafe content (defaults to NO - set to YES for eg. Adult content)
@property (retain) NSArray * categoryIdArray; // Filter results by category id - NSArray of strings (ie. can filter for multiple category Ids)
@property (retain) NSArray * postcodeArray;   // Filter results by postcode - NSArray of strings (ie. can filter for multiple postcodes)
@property CGFloat radius;                     // Location filter radius in decimal kilometers (must be > 0)
@property NSInteger locationTiers;            // Location filter radius in "location tiers" (set to -1 to remove any auto-tier limitation)
@property (retain) NSArray * suburbArray;     // Filter results by suburb - NSArray of strings (ie. can filter for multiple suburbs)
@property (retain) NSArray * stateArray;      // Filter results by state - NSArray of strings (ie. can filter for multiple states)
@property (copy) NSString * boundingBox;      // Filter results by requiring location to be inside the bounding box - see http://developers.sensis.com.au/docs/using_endpoints/Bounding_Box_Filtering
@property (retain) NSArray * contentArray;    // Filter results by content - NSArray of strings - see http://developers.sensis.com.au/docs/using_endpoints/Filtering_by_Content_Type
@property (retain) NSArray * productKeywordArray; // Filter results by keyword - NSArray of strings - see http://developers.sensis.com.au/docs/using_endpoints/Filtering_by_Product_Keyword

@end

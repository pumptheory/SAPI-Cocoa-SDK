//
//  SAPIGetListing.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIEndpoint.h"

@interface SAPIGetByListingId : SAPIEndpoint

// See also the endpoint reference for more detail: http://developers.sensis.com.au/docs/endpoint_reference/Get_by_Listing_ID

//NB: what the SAPI docs refer to as "businessId" is what you get as the key "id" in the search results

@property (copy) NSString * query;            // the unique businessId to search for (obtained from search results)
@property (copy) NSString * businessId;       // an alias for query (not KVO compliant)

// The methods to perform the query are in the baseclass header, SAPIEndpoint.h

@end

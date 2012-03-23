//
//  SAPIMetadata.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIEndpoint.h"

#import "SAPIMetadataResult.h"

extern const NSString * SAPIMetadataCategoriesKey; // @"categories"
extern const NSString * SAPIMetadataCategoryGroupsKey; // @"categoryGroups"

@interface SAPIMetadata : SAPIEndpoint

// See also the endpoint reference for more detail: http://developers.sensis.com.au/docs/endpoint_reference/Metadata

@property (assign) const NSString * dataType; // the type of metadata required
                                      // currently this can be either "categories" or "categoryGroups" - use the above constants

- (SAPIMetadataResult *)performQueryWithError:(SAPIError **)error;

- (void)performQueryAsyncSuccess:(void (^)(SAPIMetadataResult * result))successBlock
                         failure:(void (^)(SAPIError * error))failureBlock;

@end

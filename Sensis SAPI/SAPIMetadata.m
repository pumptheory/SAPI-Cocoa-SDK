//
//  SAPIMetadata.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIMetadata.h"
#import "SAPIPrivate.h"

const NSString * SAPIMetadataCategoriesKey = @"categories";
const NSString * SAPIMetadataCategoryGroupsKey = @"categoryGroups";

@implementation SAPIMetadata

@synthesize dataType;

- (NSString *)endpoint
{
    // perhaps this should be modelled as two seperate endpoints - that's really what it is.
    // sticking with one for now to match SAPI docs
    return [NSString stringWithFormat:@"metadata/%@", self.dataType];
}

- (Class)resultClass
{
    return [SAPIMetadataResult class];
}

- (NSDictionary *)queryKeys
{
    // there are actually no queryKeys since the dataType is baked into the endpoint
    return [NSDictionary dictionaryWithObjectsAndKeys:
            nil];
}

- (SAPIMetadataResult *)performQueryWithError:(SAPIError **)error
{
    return (SAPIMetadataResult *)[self _performQueryWithError:error];
}

- (void)performQueryAsyncSuccess:(void (^)(SAPIMetadataResult * result))successBlock
                         failure:(void (^)(SAPIError * error))failureBlock
{
    return [self _performQueryAsyncSuccess:(void (^)(SAPIResult * result))successBlock failure:failureBlock];
}


@end

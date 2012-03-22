//
//  SAPIEndpoint.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SAPI.h"
#import "SAPIResult.h"
#import "SAPIError.h"

@interface SAPIEndpoint : NSObject

- (NSString *)endpoint;
- (NSURL *)requestURL;
- (NSString *)baseURLString;
- (NSArray *)queryKeys;
- (NSString *)queryString;

- (SAPIResult *)performQueryWithError:(SAPIError **)error;

- (void)performQueryAsyncSuccess:(void (^)(SAPIResult * result))successBlock
                         failure:(void (^)(SAPIError * error))failureBlock;

@end

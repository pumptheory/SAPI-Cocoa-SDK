//
//  SAPIPrivate.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "AFJSONRequestOperation.h"

extern const NSInteger SAPIResultValidationError;

@interface SAPIEndpoint ()

@property (retain) AFJSONRequestOperation * requestOperation;

- (void)setupRequestForQueryAsyncSuccess:(void (^)(SAPIResult *))successBlock failure:(void (^)(SAPIError *))failureBlock;
- (NSString *)endpoint;
- (NSURL *)requestURL;
- (NSString *)baseURLString;
- (NSDictionary *)queryKeys;
- (NSString *)queryString;
- (id)queryValueForKey:(NSString *)key;

@end

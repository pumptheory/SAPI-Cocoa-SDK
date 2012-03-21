//
//  SAPIError.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SAPIErrorServerError = -1, // ie. the REST Api has returned an HTTP 500 response - see localisedDescription, failureReason and httpStatusCode
    SAPIErrorValidationError = 400, // - see localizedDescription, failureReason and validationErrors
} SAPIErrorCode;

const NSString * SAPIErrorDomain;

@interface SAPIError : NSError

+ (SAPIError *)errorWithCode:(SAPIErrorCode)code
            errorDescription:(NSString *)description
               failureReason:(NSString *)failureReason
            validationErrors:(NSArray *)validationErrors
              httpStatusCode:(NSInteger)httpStatusCode;

- (NSArray *)validationErrors; // an array of strings describing all the validation errors
- (NSInteger)httpStatusCode;

@end

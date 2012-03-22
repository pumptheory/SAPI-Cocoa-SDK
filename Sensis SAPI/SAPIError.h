//
//  SAPIError.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SAPIErrorServerError = -1, // ie. the REST Api has returned an HTTP 500 response or other unknown error - see localisedDescription, failureReason and httpStatusCode
    SAPIErrorValidationError = 400, // - see localizedDescription, failureReason and validationErrors
    SAPIErrorHttpValidationError = 401,
    SAPIErrorForbidden = 403,
    SAPIErrorRateLimited = 404, // The API returns 403 the same, but we differentiate here to make it
                                // easier to code defensively for rate limiting
    SAPIErrorRequestTooLong = 414,
    SAPIErrorServiceNotFound = 596
} SAPIErrorCode;

extern const NSString * SAPIErrorDomain;

@interface SAPIError : NSError

+ (SAPIError *)errorWithCode:(SAPIErrorCode)code
            errorDescription:(NSString *)description
               failureReason:(NSString *)failureReason
            validationErrors:(NSArray *)validationErrors
              httpStatusCode:(NSInteger)httpStatusCode;

@property (readonly) NSArray * validationErrors; // an array of strings describing all the validation errors
@property (readonly) NSInteger httpStatusCode;

@end

//
//  SAPIError.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SAPIErrorValidationError = 1000,  // corresponds to SAPI HTTP status 400
                                      // - see localizedDescription, failureReason and validationErrors
    SAPIErrorServerError              // ie. the REST Api has returned an HTTP 500 response - see localisedDescription and failureReason
} SAPIErrorCode;

const NSString * SAPIErrorDomain;

@interface SAPIError : NSError

+ (SAPIError *)errorWithCode:(SAPIErrorCode)code
            errorDescription:(NSString *)description
               failureReason:(NSString *)failureReason
            validationErrors:(NSArray *)validationErrors;

- (NSArray *)validationErrors; // an array of strings describing all the validation errors

@end

//
//  SAPIReport.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIEndpoint.h"
#import "SAPIReportResult.h"

@interface SAPIReport : SAPIEndpoint

// See also the endpoint reference for more detail: http://developers.sensis.com.au/docs/endpoint_reference/Report

@property (copy) NSString * eventName;       // required: one of Name column in http://developers.sensis.com.au/docs/using_endpoints/Reporting_Usage_Events
@property (copy) NSString * userIp;          // required: IP address of user accessing your application
@property (copy) NSArray * reportingIdArray; // required: array of strings of reportingId of listing associated with event
@property (copy) NSString * userAgent;       // User agent of user accessing your application
@property (copy) NSString * userSessionId;   // desirable: Session id of user accessing your application
@property (copy) NSString * content;         // required in some cases - see http://developers.sensis.com.au/docs/using_endpoints/Reporting_Usage_Events

- (SAPIReportResult *)performQueryWithError:(SAPIError **)error;

- (void)performQueryAsyncSuccess:(void (^)(SAPIReportResult * result))successBlock
                         failure:(void (^)(SAPIError * error))failureBlock;


@end

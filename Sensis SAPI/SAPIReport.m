//
//  SAPIReport.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIReport.h"
#import "SAPIPrivate.h"

@implementation SAPIReport

@synthesize eventName;
@synthesize userIp;
@synthesize reportingIdArray;
@synthesize userAgent;
@synthesize userSessionId;
@synthesize content;

- (void)dealloc
{
    [eventName release];
    [userIp release];
    [reportingIdArray release];
    [userAgent release];
    [userSessionId release];
    [content release];
    
    [super dealloc];
}

- (NSString *)endpoint
{
    return [NSString stringWithFormat:@"report/%@", self.eventName];
}

- (Class)resultClass
{
    return [SAPIReportResult class];
}

- (NSDictionary *)queryKeys
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"userIp", @"userIp",
            @"id", @"reportingIdArray",
            @"userAgent", @"userAgent",
            @"userSessionId", @"userSessionId",
            @"content", @"content",
            nil];
}

- (SAPIReportResult *)performQueryWithError:(SAPIError **)error
{
    return (SAPIReportResult *)[self _performQueryWithError:error];
}

- (void)performQueryAsyncSuccess:(void (^)(SAPIReportResult * result))successBlock
                         failure:(void (^)(SAPIError * error))failureBlock
{
    return [self _performQueryAsyncSuccess:(void (^)(SAPIResult * result))successBlock failure:failureBlock];
}


@end

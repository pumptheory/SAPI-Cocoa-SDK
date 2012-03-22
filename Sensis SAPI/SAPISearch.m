//
//  SAPISearch.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPISearch.h"

#import "AFJSONRequestOperation.h"

extern const NSInteger SAPIResultValidationError;

@interface SAPISearch ()

@property (retain) AFJSONRequestOperation * requestOperation;

- (void)setupRequestForQueryAsyncSuccess:(void (^)(SAPIResult *))successBlock failure:(void (^)(SAPIError *))failureBlock;

@end

@implementation SAPISearch

@synthesize query=_query;
@synthesize location=_location;
@synthesize requestOperation=_requestOperation;

- (void)dealloc
{
    [_requestOperation release], _requestOperation = nil;
    [_query release], _query = nil;
    [_location release], _requestOperation = nil;
    
    [super dealloc];
}

- (NSString *)endpoint
{
    return @"search";
}

- (NSArray *)queryKeys
{
    return [NSArray arrayWithObjects:
            @"query",
            @"location", 
            nil];
}

#define SAPISearchInitialCondition 0
#define SAPISearchWaitingCondition 1
#define SAPISearchFinishedCondition 2

- (SAPIResult *)performQueryWithError:(SAPIError **)returnError
{
    __block SAPIResult * returnResult = nil;
    NSConditionLock * lock = [[NSConditionLock alloc] initWithCondition:SAPISearchInitialCondition];
    [lock lockWhenCondition:SAPISearchInitialCondition];
        
    [self setupRequestForQueryAsyncSuccess:^(SAPIResult *result) {
        
        [lock lockWhenCondition:SAPISearchWaitingCondition];
                
        returnResult = [result retain];
        
        [lock unlockWithCondition:SAPISearchFinishedCondition];
        
    } failure:^(SAPIError *error) {
        
        [lock lockWhenCondition:SAPISearchWaitingCondition];
        
        if (returnError)
        {
            *returnError = [error retain];
        }
        
        [lock unlockWithCondition:SAPISearchFinishedCondition];
    }];
    
    self.requestOperation.successCallbackQueue = dispatch_get_global_queue(0, 0);
    self.requestOperation.failureCallbackQueue = dispatch_get_global_queue(0, 0);
    
    [self.requestOperation start];

    [lock unlockWithCondition:SAPISearchWaitingCondition];
    [lock lockWhenCondition:SAPISearchFinishedCondition];
    [lock unlockWithCondition:SAPISearchInitialCondition];
    
    if (returnError)
        [*returnError autorelease];
        
    return [returnResult autorelease];
}

- (void)performQueryAsyncSuccess:(void (^)(SAPIResult * result))successBlock
                         failure:(void (^)(SAPIError * error))failureBlock
{
    [self setupRequestForQueryAsyncSuccess:successBlock failure:failureBlock];
    [self.requestOperation start];
}

- (void)setupRequestForQueryAsyncSuccess:(void (^)(SAPIResult *))successBlock failure:(void (^)(SAPIError *))failureBlock
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[self requestURL]];
    
#ifdef DEBUG
    NSLog(@"request: %@", request);
#endif
    
    successBlock = [[successBlock copy] autorelease];
    failureBlock = [[failureBlock copy] autorelease];
    
    // TODO: handle more of http://developers.sensis.com.au/docs/reference/HTTP_Status_Codes
    
    self.requestOperation = [AFJSONRequestOperation 
                             JSONRequestOperationWithRequest:request
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                 
                                 BOOL ok = NO;
                                 NSString * failureReason = nil;
                                 NSArray * validationErrors = nil;
                                 NSString * errorDescription = @"Invalid response data";
                                 SAPIErrorCode sapiErrorCode = SAPIErrorServerError;
                                 
                                 if ([JSON isKindOfClass:[NSDictionary class]])
                                 {
                                     NSNumber * jsonCodeNumber = [JSON objectForKey:@"code"];
                                     
                                     if ([jsonCodeNumber isKindOfClass:[NSNumber class]])
                                     {
                                         NSInteger jsonCode = [jsonCodeNumber integerValue];
                                     
                                         if (jsonCode == SAPIResultSuccess || jsonCode == SAPIResultQueryModified)
                                         {
                                             ok = YES;
                                             successBlock([SAPIResult resultWithJSONDictionary:JSON]);
                                         }
                                         else if (jsonCode == SAPIResultValidationError)
                                         {
                                             // being a bit defensive about the JSON data
                                             if ([[JSON objectForKey:@"message"] isKindOfClass:[NSString class]])
                                                 failureReason = [JSON objectForKey:@"message"];
                                             
                                             if ([[JSON objectForKey:@"validationErrors"] isKindOfClass:[NSArray class]])
                                                 validationErrors = [JSON objectForKey:@"validationErrors"];
                                             
                                             errorDescription = [NSString stringWithFormat:@"%@ %@",
                                                                 failureReason,
                                                                 [validationErrors componentsJoinedByString:@", "]];
                                             
                                             sapiErrorCode = SAPIErrorValidationError;
                                         }
                                     }
                                 }
                                 
                                 if (!ok)
                                 {
                                     SAPIError * sapiError = [SAPIError errorWithCode:sapiErrorCode
                                                                     errorDescription:errorDescription
                                                                        failureReason:failureReason
                                                                     validationErrors:validationErrors
                                                                       httpStatusCode:response.statusCode];
                                     failureBlock(sapiError);
                                 }
                             }
                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                 
                                 NSUInteger statusCode = response.statusCode;
                                 SAPIError * sapiError = nil;
                                 NSString * failureReason = [error localizedFailureReason];;
                                 NSArray * validationErrors = nil;
                                 NSString * errorDescription = [error localizedDescription];
                                 SAPIErrorCode sapiErrorCode;
                                 
                                 NSString * masheryError = [[response allHeaderFields] objectForKey:@"X-Mashery-Error-Code"];
                                 if (masheryError)
                                     failureReason = masheryError;
                                 
                                 switch (statusCode)
                                 {
                                     case 400: // 400 is overloaded between json status return and http status code unfortunately
                                         sapiErrorCode = SAPIErrorHttpValidationError;
                                         break;
                                         
                                     case SAPIErrorForbidden:
                                         sapiErrorCode = SAPIErrorForbidden;
                                         break;
                                         
                                     case SAPIErrorServiceNotFound:
                                         sapiErrorCode = SAPIErrorServiceNotFound;
                                         break;
                                         
                                     case SAPIErrorRequestTooLong:
                                         sapiErrorCode = SAPIErrorRequestTooLong;
                                         break;
                                         
                                     default:
                                         sapiErrorCode = SAPIErrorServerError;
                                         break;
                                 }
                                 
                                 sapiError = [SAPIError errorWithCode:sapiErrorCode
                                                     errorDescription:errorDescription
                                                        failureReason:failureReason 
                                                     validationErrors:validationErrors
                                                       httpStatusCode:statusCode];
                                 
                                 failureBlock(sapiError);
                             }
                             ];
}

@end

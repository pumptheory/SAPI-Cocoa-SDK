//
//  SAPIEndpoint.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIEndpoint.h"
#import "AFHTTPClient.h"
#import "SAPIPrivate.h"

@implementation SAPIEndpoint

@synthesize requestOperation=_requestOperation;

- (void)dealloc
{
    [_requestOperation release], _requestOperation = nil;

    [super dealloc];
}

- (NSString *)endpoint
{
    NSAssert(0, @"You can't use SAPIEndpoint directly, you must use one of its subclasses eg. SAPISearch");
    
    return nil;
}

- (Class)resultClass
{
    NSAssert(0, @"You can't use SAPIEndpoint directly, you must use one of its subclasses eg. SAPISearch");
    
    return nil;
}

- (NSString *)baseURLString;
{
    return [NSString stringWithFormat:@"%@://%@/%@%@/%@",
            [SAPI scheme],
            [SAPI host],
            [SAPI pathPrefix],
            [SAPI environmentString],
            [self endpoint]];
}

- (NSDictionary *)dictionaryWithValuesForKeysSkippingNil:(NSArray *)keys
{
    NSMutableDictionary * res = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    for (NSString * key in keys)
    {
        id val = [self valueForKey:key];
        if (val)
        {
            [res setObject:val forKey:key];
        }
    }
    
    return res;
}

- (NSArray *)queryKeys
{
    NSAssert(0, @"You can't use SAPIEndpoint directly, you must use one of its subclasses eg. SAPISearch");

    return nil;
}

- (NSString *)queryString
{
    NSMutableArray * queryParams = [NSMutableArray arrayWithCapacity:40];
    
    [queryParams addObject:[NSString stringWithFormat:@"key=%@", [SAPI key]]];
    
    [self.queryKeys enumerateKeysAndObjectsUsingBlock:^(id propertyKey, id queryParamName, BOOL *stop) {

        id val = [self queryValueForKey:propertyKey];
        if (val)
        {
            if ([val isKindOfClass:[NSArray class]])
            {
                for (id multipleVal in val)
                {
                    [queryParams addObject:[NSString stringWithFormat:@"%@=%@",
                                            AFURLEncodedStringFromStringWithEncoding(queryParamName, NSUTF8StringEncoding),
                                            AFURLEncodedStringFromStringWithEncoding([multipleVal description], NSUTF8StringEncoding)]];
                }
            }
            else
            {
                [queryParams addObject:[NSString stringWithFormat:@"%@=%@",
                                        AFURLEncodedStringFromStringWithEncoding(queryParamName, NSUTF8StringEncoding),
                                        AFURLEncodedStringFromStringWithEncoding([val description], NSUTF8StringEncoding)]];
            }
        }
    }];
    
    return [queryParams componentsJoinedByString:@"&"];
}

- (NSURL *)requestURL
{
    NSString * requestURLString = [NSString stringWithFormat:@"%@?%@",
                                   [self baseURLString],
                                   [self queryString]];

    return [NSURL URLWithString:requestURLString];
}

- (id)queryValueForKey:(NSString *)key
{
    return [self valueForKey:key];
}

#define SAPIQueryInitialCondition 0
#define SAPIQueryWaitingCondition 1
#define SAPIQueryFinishedCondition 2

- (SAPIResult *)_performQueryWithError:(SAPIError **)returnError
{
    __block SAPIResult * returnResult = nil;
    NSConditionLock * lock = [[NSConditionLock alloc] initWithCondition:SAPIQueryInitialCondition];
    [lock lockWhenCondition:SAPIQueryInitialCondition];
    
    [self setupRequestForQueryAsyncSuccess:^(SAPIResult *result) {
        
        [lock lockWhenCondition:SAPIQueryWaitingCondition];
        
        returnResult = [result retain];
        
        [lock unlockWithCondition:SAPIQueryFinishedCondition];
        
    } failure:^(SAPIError *error) {
        
        [lock lockWhenCondition:SAPIQueryWaitingCondition];
        
        if (returnError)
        {
            *returnError = [error retain];
        }
        
        [lock unlockWithCondition:SAPIQueryFinishedCondition];
    }];
    
    self.requestOperation.successCallbackQueue = dispatch_get_global_queue(0, 0);
    self.requestOperation.failureCallbackQueue = dispatch_get_global_queue(0, 0);
    
    [self.requestOperation start];
    
    [lock unlockWithCondition:SAPIQueryWaitingCondition];
    [lock lockWhenCondition:SAPIQueryFinishedCondition];
    [lock unlockWithCondition:SAPIQueryInitialCondition];
    
    if (returnError)
        [*returnError autorelease];
    
    return [returnResult autorelease];
}

- (void)_performQueryAsyncSuccess:(void (^)(SAPIResult * result))successBlock
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
                                             successBlock([[self resultClass] resultWithJSONDictionary:JSON]);
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
                                 
                                 NSRange match;
                                 
                                 switch (statusCode)
                                 {
                                     case 400: // 400 is overloaded between json status return and http status code unfortunately
                                         sapiErrorCode = SAPIErrorHttpValidationError;
                                         break;
                                         
                                     case 403: // HTTP error 403 is shared by permission error and rate limiting
                                         
                                         match = [masheryError rangeOfString:@"OVER"];
                                         if (match.location != NSNotFound)
                                             sapiErrorCode = SAPIErrorRateLimited;
                                         else
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

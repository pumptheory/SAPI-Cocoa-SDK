//
//  SAPIEndpoint.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIEndpoint.h"
#import "AFHTTPClient.h"

@implementation SAPIEndpoint

- (NSString *)endpoint
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
    NSArray * keys = [self queryKeys];
    
    NSMutableDictionary * queryDict = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    
    [queryDict setObject:[SAPI key] forKey:@"key"];
    
    for (NSString * key in keys)
    {
        id val = [self valueForKey:key];
        if (val)
        {
            [queryDict setObject:val forKey:key];
        }
    }

    return AFQueryStringFromParametersWithEncoding(queryDict, NSUTF8StringEncoding);
}

- (NSURL *)requestURL
{
    NSString * requestURLString = [NSString stringWithFormat:@"%@?%@",
                                   [self baseURLString],
                                   [self queryString]];

    return [NSURL URLWithString:requestURLString];
}

@end

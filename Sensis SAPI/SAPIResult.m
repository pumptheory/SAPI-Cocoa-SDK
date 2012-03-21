//
//  SAPIResult.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIResult.h"

@implementation SAPIResult

@synthesize results;
@synthesize count;
@synthesize totalResults;
@synthesize currentPage;
@synthesize totalPages;
@synthesize executedQuery;
@synthesize originalQuery;
@synthesize date;
@synthesize time;
@synthesize code;

+ (SAPIResult *)resultWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    return [[[self alloc] initWithJSONDictionary:jsonDictionary] autorelease];
}

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    if ((self = [self init]))
    {
        [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([self respondsToSelector:NSSelectorFromString(key)])
            {
                [self setValue:obj forKey:key];
            }
        }];
    }
    
    return self;
}

@end

//
//  SAPISearchResult.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPISearchResult.h"

#import "SAPIISO8601DateFormatter.h"

@implementation SAPISearchResult

@synthesize results;
@synthesize count;
@synthesize totalResults;
@synthesize currentPage;
@synthesize totalPages;
@synthesize executedQuery;
@synthesize originalQuery;
@synthesize date;

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"date"] && [value isKindOfClass:[NSString class]])
    {
        SAPIISO8601DateFormatter * formatter = [[SAPIISO8601DateFormatter alloc] init];
        self.date = [formatter dateFromString:value];
        [formatter release];
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

@end

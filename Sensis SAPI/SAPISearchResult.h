//
//  SAPISearchResult.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIResult.h"

@interface SAPISearchResult : SAPIResult

@property (retain) NSArray * results; // This is currently an array of NSDictionaries.
// In the future it will become an array of custom objects (which will respond to "objectForKey:" to maintain compatibility)

@property NSUInteger count;
@property NSUInteger totalResults;
@property NSUInteger currentPage;
@property NSUInteger totalPages;
@property (retain) NSString * executedQuery;
@property (retain) NSString * originalQuery;
@property (retain) NSDate * date;

// also time, code and possibly details -- defined in the baseclass SAPIResult

@end
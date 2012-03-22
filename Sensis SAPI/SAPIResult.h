//
//  SAPIResult.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSInteger SAPIResultSuccess;
extern const NSInteger SAPIResultQueryModified;

@interface SAPIResult : NSObject

@property (retain) NSArray * results; // This is currently an array of NSDictionaries.
                                      // In the future it will become an array of custom objects (which will respond to "objectForKey:" to maintain compatibility)
@property NSUInteger count;
@property NSUInteger totalResults;
@property NSUInteger currentPage;
@property NSUInteger totalPages;
@property (retain) NSString * executedQuery;
@property (retain) NSString * originalQuery;
@property (retain) NSDate * date;
@property NSUInteger time;
@property NSInteger code;
@property (retain) NSArray * details; // This isn't documented in the API docs, it can contain an array of strings, eg: "Number of pages capped at 50, too many results found."

+ (SAPIResult *)resultWithJSONDictionary:(NSDictionary *)jsonDictionary;
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end

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

@property (retain) NSArray * results;
@property NSUInteger count;
@property NSUInteger totalResults;
@property NSUInteger currentPage;
@property NSUInteger totalPages;
@property (retain) NSString * executedQuery;
@property (retain) NSString * originalQuery;
@property (retain) NSDate * date;
@property NSUInteger time;
@property NSInteger code;

+ (SAPIResult *)resultWithJSONDictionary:(NSDictionary *)jsonDictionary;
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end

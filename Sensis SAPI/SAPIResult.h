//
//  SAPIResult.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSInteger SAPIResultSuccess;
extern const NSInteger SAPIResultQueryModified; // in the case of a search, this indicates spell checking was applied
                                                // in the case of a SAPIReport this indicates some ids were invalid and were skipped

@interface SAPIResult : NSObject

@property NSUInteger time;
@property NSInteger code;
@property (retain) NSArray * details; // This isn't documented in the API docs, it can contain an array of strings, eg: "Number of pages capped at 50, too many results found."

@end

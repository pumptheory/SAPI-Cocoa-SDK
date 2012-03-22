//
//  SAPISearch.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIEndpoint.h"
#import "SAPIResult.h"
#import "SAPIError.h"

@interface SAPISearch : SAPIEndpoint

@property (copy) NSString * query;
@property (copy) NSString * location;

@end

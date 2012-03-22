//
//  SAPIReportResult.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIResult.h"

@interface SAPIReportResult : SAPIResult

// see SAPI docs for more info: http://developers.sensis.com.au/docs/endpoint_reference/Report

@property (retain) NSArray * validationWarnings; // you get this with a 206/SAPIResultQueryModified
@property (retain) NSDate * date;                // Date and time according to the server

// also time, code and possibly details -- defined in the baseclass SAPIResult

@end

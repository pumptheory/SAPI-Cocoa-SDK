//
//  SAPIReportResult.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIReportResult.h"

@implementation SAPIReportResult

@synthesize validationWarnings;
@synthesize date;

- (void)dealloc
{
    [validationWarnings release];
    [date release];
    
    [super dealloc];
}

@end

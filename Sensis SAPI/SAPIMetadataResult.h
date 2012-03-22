//
//  SAPIMetadataResult.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 22/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIResult.h"

@interface SAPIMetadataResult : SAPIResult

@property (retain) NSArray * categories;     // populated if you requested category metadata
@property (retain) NSArray * categoryGroups; // populated if you requested categoryGroup metadata
@property (retain) NSArray * groups;         // an alias for categoryGroups (the SAPI docs are ambiguous, so we support both keys)
                                             // NB: this alias is not KVO compliant

// also time, code and possibly details -- defined in the baseclass SAPIResult

@end

//
//  SAPIMetadataViewController.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 23/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SAPIMetadataResult.h"
#import "SAPIMetadata.h"

@interface SAPIMetadataViewController : UITableViewController

@property (retain) SAPIMetadataResult * metadataResult;
@property (assign) const NSString * metadataType;

@end

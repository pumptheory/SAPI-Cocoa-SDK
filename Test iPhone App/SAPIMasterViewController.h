//
//  SAPIMasterViewController.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAPISearchViewController;

@interface SAPIMasterViewController : UITableViewController

@property (strong, nonatomic) SAPISearchViewController * searchViewController;

@end

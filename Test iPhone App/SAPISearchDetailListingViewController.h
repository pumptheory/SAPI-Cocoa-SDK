//
//  SAPISearchDetailListingViewController.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 23/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SAPISearchResult.h"

@interface SAPISearchDetailListingViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain) SAPISearchResult * searchResult;

@end

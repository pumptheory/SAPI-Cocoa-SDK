//
//  SAPISearchViewController.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAPISearchViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField * queryField;
@property (retain, nonatomic) IBOutlet UITextField * locationField;

- (IBAction)search:(id)sender;

@end

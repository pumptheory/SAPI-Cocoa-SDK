//
//  SAPISearchDetailListingViewController.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 23/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPISearchDetailListingViewController.h"

#import "SAPIReport.h"
#import "SVProgressHUD.h"

@interface SAPISearchDetailListingViewController ()

@property (retain) SAPIReport * reportQuery;

@end

@implementation SAPISearchDetailListingViewController

@synthesize textView;
@synthesize searchResult;
@synthesize reportQuery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [reportQuery release];
    [searchResult release];
    [textView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"SAPI GetListingById";
    
    NSDictionary * listing = [self.searchResult.results objectAtIndex:0];

    self.textView.text = [listing description];
    
    // send the appearance report to Sensis SAPI - normally you wouldn't provide user feedback
    self.reportQuery = [[SAPIReport alloc] init];
    self.reportQuery.eventName = @"appearance";
    self.reportQuery.reportingIdArray = [NSArray arrayWithObject:[listing objectForKey:@"reportingId"]];
    self.reportQuery.userIp = @"10.0.0.1"; // need to get the user's external IP in production -- we are asking SAPI to remove this requirement for mobile apps
    
    [SVProgressHUD showWithStatus:@"SAPI Reporting..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self.reportQuery performQueryAsyncSuccess:^(SAPIReportResult *result) {
        [SVProgressHUD dismissWithSuccess:@"Reported appearance" afterDelay:2];
    } failure:^(SAPIError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription] afterDelay:4];
    }];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

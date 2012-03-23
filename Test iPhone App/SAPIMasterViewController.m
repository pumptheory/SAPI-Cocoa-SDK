//
//  SAPIMasterViewController.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIMasterViewController.h"

#import "SAPISearchViewController.h"
#import "SAPIMetadataViewController.h"
#import "SAPIMetadata.h"
#import "SVProgressHUD.h"

@interface SAPIMasterViewController ()

@property (strong, nonatomic) SAPISearchViewController * searchViewController;
@property (strong, nonatomic) SAPIMetadataViewController * metadataViewController;
@property (strong) SAPIMetadata * metadataQuery;

@end

@implementation SAPIMasterViewController

@synthesize searchViewController=_searchViewController;
@synthesize metadataViewController=_metadataViewController;
@synthesize metadataQuery=_metadataQuery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.title = @"SAPI Endpoints";
    }
    return self;
}
							
- (void)dealloc
{
    [_searchViewController release], _searchViewController = nil;
    [_metadataViewController release], _metadataViewController = nil;
    [_metadataQuery release], _metadataQuery = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Search";
            cell.detailTextLabel.text = @"Also GetListingById and Report";
            break;
            
        case 1:
            cell.textLabel.text = @"Categories";
            cell.detailTextLabel.text = @"Metadata endpoint";
            break;
            
        case 2:
            cell.textLabel.text = @"CategoryGroups";
            cell.detailTextLabel.text = @"Metadata endpoint";
            break;

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            if (!self.searchViewController)
            {
                self.searchViewController = [[[SAPISearchViewController alloc] initWithNibName:@"SAPISearchViewController" bundle:nil] autorelease];
            }
            [self.navigationController pushViewController:self.searchViewController animated:YES];
            break;
            
        case 1:
        case 2:            
            [SVProgressHUD showWithStatus:@"Getting Metadata" maskType:SVProgressHUDMaskTypeBlack];
            
            self.metadataQuery = [[[SAPIMetadata alloc] init] autorelease];
            self.metadataQuery.dataType = indexPath.row == 1 ? SAPIMetadataCategoriesKey : SAPIMetadataCategoryGroupsKey;
            
            [self.metadataQuery performQueryAsyncSuccess:^(SAPIMetadataResult *result) {
                [SVProgressHUD dismiss];
                
                if (!self.metadataViewController)
                    self.metadataViewController = [[[SAPIMetadataViewController alloc] initWithNibName:@"SAPIMetadataViewController" bundle:nil] autorelease];

                self.metadataViewController.metadataResult = result;
                self.metadataViewController.metadataType = self.metadataQuery.dataType;
                
                [self.navigationController pushViewController:self.metadataViewController animated:YES];
            } failure:^(SAPIError *error) {
                [SVProgressHUD dismissWithError:[error localizedDescription] afterDelay:4];
            }];
            
            break;
    }
}

@end

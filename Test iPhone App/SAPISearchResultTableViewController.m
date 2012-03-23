//
//  SAPISearchResultTableViewController.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 23/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPISearchResultTableViewController.h"

#import "SAPISearchDetailListingViewController.h"
#import "SAPIGetByListingId.h"
#import "SVProgressHUD.h"

@interface SAPISearchResultTableViewController ()

@property (retain) SAPIGetByListingId * listingQuery;

@end

@implementation SAPISearchResultTableViewController

@synthesize searchResult=_searchResult;
@synthesize listingQuery=_listingQuery;

- (void)dealloc
{
    [_searchResult release];
    [_listingQuery release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"SAPISearchResult";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.searchResult.results count]; // in a real app you would want to auto-load the following result pages
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0)
    {
        NSDictionary * listingDetail = [self.searchResult.results objectAtIndex:indexPath.row];
        NSDictionary * addressDetail = [listingDetail objectForKey:@"primaryAddress"];
        
        cell.textLabel.text = [listingDetail objectForKey:@"name"];
        cell.detailTextLabel.text = [addressDetail objectForKey:@"suburb"];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%d of %d total results", self.searchResult.count, self.searchResult.totalResults];
        
        if (self.searchResult.code == SAPIResultQueryModified)
        {
            cell.detailTextLabel.text = @"Query string was modified by Spell Checker";
        }
        else
        {
            NSArray * details = self.searchResult.details;
            cell.detailTextLabel.text = details ? [details objectAtIndex:0] : @"";
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSDictionary * listingDetail = [self.searchResult.results objectAtIndex:indexPath.row];
        
        self.listingQuery = [[[SAPIGetByListingId alloc] init] autorelease];
        self.listingQuery.businessId = [listingDetail objectForKey:@"id"];
        
        [self.listingQuery performQueryAsyncSuccess:^(SAPISearchResult *result) {
            [SVProgressHUD dismiss];
            
            if ([result.results count])
            {
                SAPISearchDetailListingViewController * vc = [[[SAPISearchDetailListingViewController alloc] initWithNibName:@"SAPISearchDetailListingViewController" bundle:nil] autorelease];
                
                vc.searchResult = result;

                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [SVProgressHUD dismissWithError:@"Results array was empty" afterDelay:4];
            }
            
        } failure:^(SAPIError *error) {
            [SVProgressHUD dismissWithError:[error localizedDescription] afterDelay:4];
        }];
    }
}

@end

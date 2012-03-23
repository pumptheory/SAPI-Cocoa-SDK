//
//  SAPIMetadataViewController.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 23/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIMetadataViewController.h"

@implementation SAPIMetadataViewController

@synthesize metadataResult;
@synthesize metadataType;


- (void)dealloc
{
    [metadataResult release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    self.title = [self.metadataType copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.metadataType == SAPIMetadataCategoriesKey) // it's a const, so this is safe
        return [self.metadataResult.categories count];
    else
        return [self.metadataResult.categoryGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MetadataCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (self.metadataType == SAPIMetadataCategoriesKey) // it's a const, so this is safe
    {
        NSDictionary * category = [self.metadataResult.categories objectAtIndex:indexPath.row];
        cell.textLabel.text = [category objectForKey:@"name"];
        cell.detailTextLabel.text = @"";
    }
    else
    {
        NSDictionary * categoryGroup = [self.metadataResult.categoryGroups objectAtIndex:indexPath.row];
        cell.textLabel.text = [categoryGroup objectForKey:@"name"];
        NSArray * childrenNames = [categoryGroup valueForKeyPath:@"children.name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Children: %@", [childrenNames componentsJoinedByString:@", "]];
    }
    
    return cell;
}

@end

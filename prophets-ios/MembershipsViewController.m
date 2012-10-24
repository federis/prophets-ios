//
//  LeagueMembershipsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/28/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "MembershipsViewController.h"
#import "MembershipCell.h"
#import "Membership.h"
#import "User.h"
#import "UIBarButtonItem+Additions.h"

@interface MembershipsViewController ()
@end

@implementation MembershipsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:nil action:nil];
    
    self.navigationItem.leftBarButtonItems = @[item];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TmpCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

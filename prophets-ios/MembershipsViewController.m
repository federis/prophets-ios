//
//  LeagueMembershipsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/28/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>

#import "MembershipsViewController.h"
#import "MembershipCell.h"
#import "Membership.h"
#import "User.h"

@interface MembershipsViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation MembershipsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = @"/memberships";
    self.tableController.variableHeightRows = YES;
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    self.tableController.sortDescriptors = [NSArray arrayWithObject:descriptor];
    
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
    
    [self.tableController mapObjectsWithClass:[Membership class] toTableCellsWithMapping:[MembershipCell mappingForCell]];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MembershipCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([MembershipCell class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([User currentUser])
        [self.tableController loadTable];
}

@end

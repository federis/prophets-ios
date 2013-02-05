//
//  ManageUsersViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class AdminMembershipCell, League;

@interface ManageUsersViewController : FFFetchedResultsViewController

@property (nonatomic, strong) AdminMembershipCell *measuringCell;
@property (nonatomic, strong) League *league;


@end

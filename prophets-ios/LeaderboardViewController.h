//
//  StatsViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class Membership, LeaderCell;

@interface LeaderboardViewController : FFFetchedResultsViewController

@property (nonatomic, strong) Membership *membership;
@property (nonatomic, strong) LeaderCell *measuringCell;

@end

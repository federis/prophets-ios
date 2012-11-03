//
//  BetListViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/29/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class Membership, BetCell, LeaguePerformanceView;

@interface BetListViewController : FFFetchedResultsViewController

@property (nonatomic, strong) Membership *membership;
@property (nonatomic, strong) BetCell *measuringCell;

@property (weak, nonatomic) IBOutlet UIButton *timeSortButton;
@property (weak, nonatomic) IBOutlet UIButton *performanceSortButton;

@end

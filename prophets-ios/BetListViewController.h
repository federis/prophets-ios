//
//  BetListViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/29/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class Membership, BetCell;

@interface BetListViewController : FFFetchedResultsViewController

@property (nonatomic, strong) Membership *membership;
@property (nonatomic, strong) BetCell *measuringCell;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitedToBetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalWorthLabel;
@property (weak, nonatomic) IBOutlet UIView *rankBackground;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankOutOfLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeSortButton;
@property (weak, nonatomic) IBOutlet UIButton *performanceSortButton;

-(NSDecimalNumber *)totalWorth;

@end

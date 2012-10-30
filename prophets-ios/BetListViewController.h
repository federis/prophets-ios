//
//  BetListViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/29/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class League, BetCell;

@interface BetListViewController : FFFetchedResultsViewController

@property (nonatomic, strong) League *league;
@property (nonatomic, strong) BetCell *measuringCell;

@end

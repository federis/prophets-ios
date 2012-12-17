//
//  JoinLeagueViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/7/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@class League, LeagueDetailCell;

@interface JoinLeagueViewController : FFBaseTableViewController

@property (nonatomic, strong) League *league;
@property LeagueDetailCell *measuringCell;

@end

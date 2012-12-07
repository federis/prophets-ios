//
//  LeagueListViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class Tag, LeagueCell;

@interface LeagueListViewController : FFFetchedResultsViewController

@property (nonatomic, strong) Tag *tag;

@property (nonatomic, strong) LeagueCell *measuringCell;

@end

//
//  QuestionsViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/23/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class League;

@interface QuestionsViewController : FFFetchedResultsViewController

@property (nonatomic, strong) League *league;

@end

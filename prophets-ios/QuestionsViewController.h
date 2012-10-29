//
//  QuestionsViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/23/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class League, QuestionCell;

@interface QuestionsViewController : FFFetchedResultsViewController

@property (nonatomic, strong) League *league;
@property (nonatomic, strong) QuestionCell *measuringCell;

@property (weak, nonatomic) IBOutlet UILabel *leagueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionCountLabel;
@property (weak, nonatomic) IBOutlet UIView *headerBackgroundView;

@end

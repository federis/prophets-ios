//
//  JudgeViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 2/4/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class Question, JudgeAnswerCell;

@interface JudgeViewController : FFFetchedResultsViewController

@property (nonatomic, strong) JudgeAnswerCell *measuringCell;
@property (nonatomic, strong) Question *question;

@end

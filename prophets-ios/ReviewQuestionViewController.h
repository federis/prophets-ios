//
//  ReviewQuestionViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/16/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@class Question, AnswerCell;

@interface ReviewQuestionViewController : FFBaseTableViewController

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) AnswerCell *measuringCell;
@property (nonatomic, strong) NSArray *answers;

@end

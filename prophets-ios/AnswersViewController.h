//
//  AnswersViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@class Membership, Question, AnswerCell, CommentCell, CommentsController;

@interface AnswersViewController : FFBaseTableViewController

@property (nonatomic, strong) Membership *membership;
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSNumber *questionId;
@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, strong) AnswerCell *measuringCell;
@property (nonatomic, strong) CommentCell *commentMeasuringCell;

@property (nonatomic, strong) CommentsController *commentsController;

@end

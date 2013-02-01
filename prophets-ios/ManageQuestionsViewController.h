//
//  ManageQuestionsViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@class AdminQuestionCell, League;

typedef enum : NSUInteger {
    FFQuestionCurrentlyRunning,
    FFQuestionUnapproved,
    FFQuestionPendingJudgement,
    FFQuestionComplete
} FFQuestionScope;

@interface ManageQuestionsViewController : FFFetchedResultsViewController

@property (nonatomic, strong) AdminQuestionCell *measuringCell;
@property (nonatomic, strong) League *league;
@property (nonatomic, assign) FFQuestionScope scope;

@end

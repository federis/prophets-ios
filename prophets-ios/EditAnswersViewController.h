//
//  EditAnswersViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@class Question;

@interface EditAnswersViewController : FFBaseTableViewController

@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSMutableArray *tempContexts;

@property (nonatomic, strong) FFLabel *probabilitiesSum;

@end

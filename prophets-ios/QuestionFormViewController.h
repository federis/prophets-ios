//
//  QuestionFormViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/13/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormViewController.h"

@class League, Question;

@interface QuestionFormViewController : FFFormViewController

@property (nonatomic, strong) League *league;
@property (nonatomic, strong) Question *question;

@end

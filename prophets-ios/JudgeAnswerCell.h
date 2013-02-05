//
//  JudgeAnswerCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 2/4/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class Answer;

@interface JudgeAnswerCell : FFBaseCell

@property (nonatomic, strong) Answer *answer;

@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIButton *incorrectButton;
@property (weak, nonatomic) IBOutlet UIButton *correctButton;
@property (weak, nonatomic) IBOutlet UILabel *correctnessLabel;

-(CGFloat)heightForCellWithAnswer:(Answer *)answer;

@end

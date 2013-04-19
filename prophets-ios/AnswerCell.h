//
//  AnswerCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class Answer;

@interface AnswerCell : FFBaseCell

@property (nonatomic, strong) Answer *answer;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *payoutLabel;

-(CGFloat)heightForCellWithAnswer:(Answer *)answer;

@end

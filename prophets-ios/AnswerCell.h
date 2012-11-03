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

-(CGFloat)heightForCellWithAnswer:(Answer *)answer;

@end

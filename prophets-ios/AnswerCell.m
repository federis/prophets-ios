//
//  AnswerCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "AnswerCell.h"
#import "Answer.h"
#import "Utilities.h"

@implementation AnswerCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)setAnswer:(Answer *)answer{
    self.answerLabel.text = answer.content;
    self.answerLabel.frame = RectWithNewHeight([Utilities heightForString:answer.content
                                                                         withFont:self.answerLabel.font
                                                                            width:self.answerLabel.frame.size.width],
                                                       self.answerLabel.frame);
    
    if(answer.hasBeenJudged){
        self.showsAccessoryView = NO;
        self.correctnessLabel.hidden = NO;
        self.correctnessLabel.text = answer.isCorrect ? @"Correct" : @"Incorrect";
    }
    else{
        self.showsAccessoryView = YES;
        self.correctnessLabel.hidden = YES;
    }
}

-(CGFloat)heightForCellWithAnswer:(Answer *)answer{
    return 23 + [Utilities heightForString:answer.content
                                  withFont:self.answerLabel.font
                                     width:self.answerLabel.frame.size.width];
}

@end

//
//  JudgeAnswerCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 2/4/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "JudgeAnswerCell.h"
#import "Answer.h"
#import "Utilities.h"

@implementation JudgeAnswerCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UIImage *redImage = [[UIImage imageNamed:@"red_button_insets.png"] resizableImageWithCapInsets:insets];
    [self.incorrectButton setBackgroundImage:redImage forState:UIControlStateNormal];
    
    UIImage *greenImage = [[UIImage imageNamed:@"green_button_insets.png"] resizableImageWithCapInsets:insets];
    [self.correctButton setBackgroundImage:greenImage forState:UIControlStateNormal];
}

-(void)setAnswer:(Answer *)answer{
    _answer = answer;
    
    self.answerLabel.text = answer.content;
    
    self.answerLabel.frame = RectWithNewHeight([Utilities heightForString:answer.content
                                                                 withFont:self.answerLabel.font
                                                                    width:self.answerLabel.frame.size.width], self.answerLabel.frame);
    
    if (answer.hasBeenJudged) {
        self.correctButton.hidden = YES;
        self.incorrectButton.hidden = YES;
        
        self.correctnessLabel.hidden = NO;
        self.correctnessLabel.text = answer.isCorrect ? @"Correct" : @"Incorrect";
    }
    else{
        self.correctButton.hidden = NO;
        self.incorrectButton.hidden = NO;
        
        self.correctnessLabel.hidden = YES;
    }
}

-(CGFloat)heightForCellWithAnswer:(Answer *)answer{
    return 55 + [Utilities heightForString:answer.content
                                  withFont:self.answerLabel.font
                                     width:self.answerLabel.frame.size.width];
}

@end

//
//  AnswerCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "AnswerCell.h"
#import "Answer.h"
#import "NSDecimalNumber+Additions.h"
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
    
    self.detailsLabel.text = [NSString stringWithFormat:@"%@ %@ · %@ wagered", answer.betsCount,
                                                                               [Utilities pluralize:answer.betsCount singular:@"bet" plural:@"bets"],
                                                                               answer.betTotal.currencyString];
    
    if(answer.hasBeenJudged){
        self.showsAccessoryView = NO;
        self.correctnessLabel.hidden = NO;
        self.correctnessLabel.text = answer.isCorrect ? @"Correct" : @"Incorrect";
        
        self.payoutLabel.hidden = YES;
    }
    else{
        self.showsAccessoryView = YES;
        self.correctnessLabel.hidden = YES;
        
        self.payoutLabel.hidden = NO;
        self.payoutLabel.text = answer.dollarBetPayoutString;
    }
}

-(CGFloat)heightForCellWithAnswer:(Answer *)answer{
    CGFloat extra = 53;
    if (answer.hasBeenJudged) {
        extra = 33;
    }
    return extra + [Utilities heightForString:answer.content
                                  withFont:self.answerLabel.font
                                     width:self.answerLabel.frame.size.width];
}

@end

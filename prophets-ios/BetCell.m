//
//  BetCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/29/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "BetCell.h"
#import "Bet.h"
#import "Answer.h"
#import "Question.h"

@implementation BetCell

-(void)setBet:(Bet *)bet{
    self.answerLabel.text = bet.answer.content;
    self.questionLabel.text = bet.answer.question.content;
    self.betAmountLabel.text = bet.amount.currencyString;
}

-(CGFloat)heightForCellWithBet:(Bet *)bet{
    return 44;
}

@end

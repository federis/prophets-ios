//
//  BetCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/29/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BetCell.h"
#import "UIColor+Additions.h"
#import "Bet.h"
#import "Answer.h"
#import "Question.h"

@implementation BetCell

-(void)setBet:(Bet *)bet{
    self.answerLabel.text = bet.answer.content;
    self.questionLabel.text = bet.answer.question.content;
    self.betInfoLabel.text = [NSString stringWithFormat:@"You bet %@ on %@ odds",
                              bet.amount.currencyString, bet.oddsString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mma zzz MMM dd,yyyy";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    self.betSubmittedLabel.text = [NSString stringWithFormat:@"Bet submitted: %@",
                                   [dateFormatter stringFromDate:bet.createdAt]];
    
    if (bet.hasBeenJudged) { //judged bet
        self.statusLabel.text = @"Closed";
        self.statusLabel.textColor = [UIColor blackColor];
        self.statusDot.backgroundColor = [UIColor blackColor];
        
        if ([bet.payout compare:[NSNumber numberWithInt:0]] == NSOrderedSame) { // incorrect bet
            self.payoutLabelBackground.backgroundColor = [UIColor ffRedColor];
            self.payoutLabel.text = bet.amount.currencyString;
            self.payoutSubtextLabel.text = @"you lost";
        }
        else{ //correct bet
            self.payoutLabelBackground.backgroundColor = [UIColor ffGreenColor];
            self.payoutLabel.text = bet.payout.currencyString;
            self.payoutSubtextLabel.text = @"you won";
        }
        
        self.bettingEndLabel.text = [NSString stringWithFormat:@"Betting ended: %@",
                                       [dateFormatter stringFromDate:bet.answer.bettingEndedAt]];
        
    }
    else{
        self.payoutLabelBackground.backgroundColor = [UIColor ffGrayColor];
        self.payoutLabel.text = bet.potentialPayout.currencyString;
        self.payoutSubtextLabel.text = @"potential payout";
        
        if (bet.answer.isOpenForBetting) { //bet in an answer that is still open for betting
            self.bettingEndLabel.text = [NSString stringWithFormat:@"Betting ends: %@",
                                         [dateFormatter stringFromDate:bet.answer.question.bettingClosesAt]];
            
            self.statusLabel.text = @"Open";
            self.statusLabel.textColor = [UIColor ffGreenColor];
            self.statusDot.backgroundColor = [UIColor ffGreenColor];
            
        }
        else{ //bet in a question where answer has closed, but answer has not yet been judged
            self.bettingEndLabel.text = [NSString stringWithFormat:@"Betting ended: %@",
                                         [dateFormatter stringFromDate:bet.answer.question.bettingClosesAt]];
            
            self.statusLabel.text = @"Closed, Waiting to be judged";
            self.statusLabel.textColor = [UIColor ffRedColor];
            self.statusDot.backgroundColor = [UIColor ffRedColor];
            
        }
    }
}

-(void)awakeFromNib{
    self.statusDot.layer.cornerRadius = 5;
    self.payoutLabelBackground.layer.cornerRadius = 5;
}

-(CGFloat)heightForCellWithBet:(Bet *)bet{
    return 100;
}

@end

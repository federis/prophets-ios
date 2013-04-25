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
#import "Utilities.h"

@implementation BetCell

-(void)setBet:(Bet *)bet{
    if(!bet || !bet.answer || !bet.answer.question){
        [self prepForLoadingBet];
    }
    else{
        [self prepForBet];
        
        self.answerLabel.text = bet.answer.content;
        self.questionLabel.text = bet.answer.question.content;
        self.betInfoLabel.text = [NSString stringWithFormat:@"%@ bet on %@ odds",
                                  bet.amount.currencyString, bet.oddsString];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mma zzz MMM dd,yyyy";
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        
        self.betSubmittedLabel.text = [NSString stringWithFormat:@"Submitted: %@",
                                       [dateFormatter stringFromDate:bet.createdAt]];
        
        if (bet.hasBeenJudged) { //judged bet
            self.statusLabel.text = @"Closed";
            self.statusLabel.textColor = [UIColor blackColor];
            self.statusDot.backgroundColor = [UIColor blackColor];
            
            if ([bet.payout compare:[NSNumber numberWithInt:0]] == NSOrderedSame) { // incorrect bet
                self.payoutLabelBackground.backgroundColor = [UIColor ffRedColor];
                self.payoutLabel.text = bet.amount.currencyString;
                self.payoutSubtextLabel.text = @"lost";
            }
            else{ //correct bet
                self.payoutLabelBackground.backgroundColor = [UIColor ffGreenColor];
                self.payoutLabel.text = bet.payout.currencyString;
                self.payoutSubtextLabel.text = @"won";
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
        
        [self layoutLabels];
    }
}

-(void)prepForLoadingBet{
    self.statusLabel.hidden = YES;
    self.statusDot.hidden = YES;
    self.questionLabel.hidden = YES;
    self.answerLabel.hidden = YES;
    self.betInfoLabel.hidden = YES;
    self.payoutLabelBackground.hidden = YES;
    self.payoutLabel.hidden = YES;
    self.payoutSubtextLabel.hidden = YES;
    self.betSubmittedLabel.hidden = YES;
    self.bettingEndLabel.hidden = YES;
    
    self.loadingBetLabel.hidden = NO;
}

-(void)prepForBet{
    self.statusLabel.hidden = NO;
    self.statusDot.hidden = NO;
    self.questionLabel.hidden = NO;
    self.answerLabel.hidden = NO;
    self.betInfoLabel.hidden = NO;
    self.payoutLabelBackground.hidden = NO;
    self.payoutLabel.hidden = NO;
    self.payoutSubtextLabel.hidden = NO;
    self.betSubmittedLabel.hidden = NO;
    self.bettingEndLabel.hidden = NO;
    
    self.loadingBetLabel.hidden = YES;
}

-(void)layoutLabels{
    CGFloat questionHeight = [Utilities heightForString:self.questionLabel.text
                                              withFont:self.questionLabel.font
                                                 width:self.questionLabel.frame.size.width];

    self.questionLabel.frame = RectWithNewHeight(questionHeight, self.questionLabel.frame);
    
    CGFloat answerHeight = [Utilities heightForString:self.answerLabel.text
                                               withFont:self.answerLabel.font
                                                  width:self.answerLabel.frame.size.width];
    
    CGSize answerSize = CGSizeMake(self.answerLabel.frame.size.width, answerHeight);
    self.answerLabel.frame = RectBelowRectWithSpacingAndSize(self.questionLabel.frame, 0, answerSize);
}

-(void)awakeFromNib{
    self.statusDot.layer.cornerRadius = 5;
    self.payoutLabelBackground.layer.cornerRadius = 5;
}

-(CGFloat)heightForCellWithBet:(Bet *)bet{
    if(!bet || !bet.answer || !bet.answer.question){
        return 95;
    }
    else{
        CGFloat questionHeight = [Utilities heightForString:bet.answer.question.content
                                                   withFont:self.questionLabel.font
                                                      width:self.questionLabel.frame.size.width];
        
        CGFloat answerHeight = [Utilities heightForString:bet.answer.content
                                                 withFont:self.answerLabel.font
                                                    width:self.answerLabel.frame.size.width];

        return questionHeight + answerHeight + 54;
    }
}

@end

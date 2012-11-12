//
//  BetCellTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/1/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFApplicationTest.h"
#import "BetCell.h"
#import "Bet.h"
#import "Answer.h"
#import "Question.h"
#import "UIColor+Additions.h"

@interface BetCellTests : FFApplicationTest

@property (nonatomic, strong) Bet *bet;
@property (nonatomic, strong) BetCell *cell;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation BetCellTests

-(void)setUp{
    [super setUp];
    self.bet = [Factories betFactory];
    self.bet.answer = [Factories answerFactory];
    self.bet.answer.question = [Factories questionFactory];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BetCell" owner:self options:nil];
    self.cell = (BetCell *)[nib objectAtIndex:0];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"hh:mma zzz MMM dd,yyyy";
    self.dateFormatter.timeZone = [NSTimeZone localTimeZone];
}

-(void)tearDown{
    [super tearDown];
    self.bet = nil;
}

-(void)testCommonAttributes{
    self.cell.bet = self.bet;
    
    STAssertEqualObjects(self.cell.questionLabel.text, self.bet.answer.question.content, nil);
    STAssertEqualObjects(self.cell.answerLabel.text, self.bet.answer.content, nil);
    NSString *infoStr = [NSString stringWithFormat:@"You bet %@ on %@ odds", self.bet.amount.currencyString, self.bet.oddsString];
    STAssertEqualObjects(self.cell.betInfoLabel.text, infoStr, nil);
    
    NSString *submittedStr = [NSString stringWithFormat:@"Bet submitted: %@",[self.dateFormatter stringFromDate:self.bet.createdAt]];
    STAssertEqualObjects(self.cell.betSubmittedLabel.text, submittedStr, nil);
}

-(void)testCorrectJudgedBet{
    self.bet.payout = [NSDecimalNumber decimalNumberWithString:@"100"];
    self.bet.answer.judgedAt = [NSDate dateWithTimeIntervalSinceNow:-1*DAY];
    
    self.cell.bet = self.bet;
    
    STAssertEqualObjects(self.cell.statusLabel.text, @"Closed", nil);
    STAssertEqualObjects(self.cell.statusLabel.textColor, [UIColor blackColor], nil);
    STAssertEqualObjects(self.cell.statusDot.backgroundColor, [UIColor blackColor], nil);
    
    STAssertEqualObjects(self.cell.payoutLabelBackground.backgroundColor, [UIColor ffGreenColor], nil);
    STAssertEqualObjects(self.cell.payoutLabel.text, self.bet.payout.currencyString, nil);
    STAssertEqualObjects(self.cell.payoutSubtextLabel.text, @"you won", nil);
    
    NSString *bettingEndStr = [NSString stringWithFormat:@"Betting ended: %@", [self.dateFormatter stringFromDate:self.bet.answer.bettingEndedAt]];
    STAssertEqualObjects(self.cell.bettingEndLabel.text, bettingEndStr, nil);
}

-(void)testIncorrectJudgedBet{
    self.bet.payout = [NSDecimalNumber decimalNumberWithString:@"0"];
    self.bet.answer.judgedAt = [NSDate dateWithTimeIntervalSinceNow:-1*DAY];
    
    self.cell.bet = self.bet;
    
    STAssertEqualObjects(self.cell.statusLabel.text, @"Closed", nil);
    STAssertEqualObjects(self.cell.statusLabel.textColor, [UIColor blackColor], nil);
    STAssertEqualObjects(self.cell.statusDot.backgroundColor, [UIColor blackColor], nil);
    
    STAssertEqualObjects(self.cell.payoutLabelBackground.backgroundColor, [UIColor ffRedColor], nil);
    STAssertEqualObjects(self.cell.payoutLabel.text, self.bet.amount.currencyString, nil);
    STAssertEqualObjects(self.cell.payoutSubtextLabel.text, @"you lost", nil);
    
    NSString *bettingEndStr = [NSString stringWithFormat:@"Betting ended: %@", [self.dateFormatter stringFromDate:self.bet.answer.bettingEndedAt]];
    STAssertEqualObjects(self.cell.bettingEndLabel.text, bettingEndStr, nil);
}

-(void)testClosedBettingNotJudgedBet{
    self.bet.payout = nil;
    self.bet.answer.judgedAt = nil;
    self.bet.answer.question.bettingClosesAt = [NSDate dateWithTimeIntervalSinceNow:-1*DAY];
    
    self.cell.bet = self.bet;
    
    STAssertEqualObjects(self.cell.statusLabel.text, @"Closed, Waiting to be judged", nil);
    STAssertEqualObjects(self.cell.statusLabel.textColor, [UIColor ffRedColor], nil);
    STAssertEqualObjects(self.cell.statusDot.backgroundColor, [UIColor ffRedColor], nil);
    
    STAssertEqualObjects(self.cell.payoutLabelBackground.backgroundColor, [UIColor ffGrayColor], nil);
    STAssertEqualObjects(self.cell.payoutLabel.text, self.bet.potentialPayout.currencyString, nil);
    STAssertEqualObjects(self.cell.payoutSubtextLabel.text, @"potential payout", nil);
    
    NSString *bettingEndStr = [NSString stringWithFormat:@"Betting ended: %@", [self.dateFormatter stringFromDate:self.bet.answer.bettingEndedAt]];
    STAssertEqualObjects(self.cell.bettingEndLabel.text, bettingEndStr, nil);
}

-(void)testOpenQuestionBet{
    self.bet.payout = nil;
    self.bet.answer.judgedAt = nil;
    
    self.cell.bet = self.bet;
    
    STAssertEqualObjects(self.cell.statusLabel.text, @"Open", nil);
    STAssertEqualObjects(self.cell.statusLabel.textColor, [UIColor ffGreenColor], nil);
    STAssertEqualObjects(self.cell.statusDot.backgroundColor, [UIColor ffGreenColor], nil);
    
    STAssertEqualObjects(self.cell.payoutLabelBackground.backgroundColor, [UIColor ffGrayColor], nil);
    STAssertEqualObjects(self.cell.payoutLabel.text, self.bet.potentialPayout.currencyString, nil);
    STAssertEqualObjects(self.cell.payoutSubtextLabel.text, @"potential payout", nil);
    
    NSString *bettingEndStr = [NSString stringWithFormat:@"Betting ends: %@", [self.dateFormatter stringFromDate:self.bet.answer.question.bettingClosesAt]];
    STAssertEqualObjects(self.cell.bettingEndLabel.text, bettingEndStr, nil);
}

@end

//
//  CreateBetViewTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/7/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFApplicationTest.h"
#import "CreateBetView.h"
#import "League.h"
#import "Membership.h"
#import "Bet.h"

@interface CreateBetViewTests : FFApplicationTest

@property (nonatomic, strong) CreateBetView *createBetView;

@end

@implementation CreateBetViewTests

-(void)setUp{
    [super setUp];
    self.createBetView = [[CreateBetView alloc] init];
    Answer *answer = [Factories answerFactory];
    Membership *membership = [Factories membershipFactory];
    membership.league = [Factories leagueFactory];
    membership.league.maxBet = [NSDecimalNumber decimalNumberWithString:@"100000"];
    
    [self.createBetView setAnswer:answer];
    [self.createBetView setMembership:membership];
}

-(void)tearDown{
    [super tearDown];
    
    self.createBetView = nil;
}

-(void)testChangeSlider{
    [self.createBetView.betAmountSlider setValue:5];
    [self.createBetView performSelector:@selector(sliderChanged:) withObject:self.createBetView.betAmountSlider];
    
    STAssertEqualObjects(self.createBetView.bet.amount, [NSDecimalNumber decimalNumberWithString:@"5"], nil);
    STAssertEqualObjects(self.createBetView.payoutLabel.text, self.createBetView.bet.potentialPayout.currencyString, nil);
    STAssertEqualObjects(self.createBetView.betAmountTextField.text, @"5.00", nil);
    
}

-(void)testChangeTextField{
    objc_msgSend(self.createBetView, @selector(textField:shouldChangeCharactersInRange:replacementString:), self.createBetView.betAmountTextField, NSMakeRange(0, 1), @"10");
    
    STAssertEqualObjects(self.createBetView.bet.amount, [NSDecimalNumber decimalNumberWithString:@"10"], nil);
    STAssertEqualObjects(self.createBetView.payoutLabel.text, self.createBetView.bet.potentialPayout.currencyString, nil);
    STAssertTrue(self.createBetView.betAmountSlider.value == 10, nil);
}

@end

//
//  BetTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/1/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFLogicTest.h"
#import "Bet.h"

@interface BetTests : FFLogicTest

@end

@implementation BetTests

-(void)testBetOddsString{
    Bet *bet = [Factories betFactory];
    bet.probability = [NSDecimalNumber decimalNumberWithString:@"0.2"];
    
    STAssertEqualObjects(bet.oddsString, @"4:1", @"Bet odds string is incorrect");
}

-(void)testPotentialPayout{
    Bet *bet = [Factories betFactory];
    bet.probability = [NSDecimalNumber decimalNumberWithString:@"0.2"];
    bet.amount = [NSDecimalNumber decimalNumberWithString:@"2"];
    
    STAssertEqualObjects(bet.potentialPayout, [NSDecimalNumber decimalNumberWithString:@"10"], @"Bet potential payout is incorrect");
}

@end

//
//  BetRequestTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/30/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFRequestTest.h"
#import "Bet.h"
#import "League.h"
#import "Answer.h"
#import "Question.h"
#import "Membership.h"

@interface BetRequestTests : FFRequestTest

@end

@implementation BetRequestTests

-(void)testGetLeagueBets{
    League *league = [Factories leagueFactory];
    __block RKMappingResult *result;
    
    [RKTestNotificationObserver waitForNotificationWithName:RKObjectRequestOperationDidFinishNotification usingBlock:^{
        [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"bets" ofObject:league parameters:nil
         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
             result = mappingResult;
         }
         failure:^(RKObjectRequestOperation *operation, NSError *error){
             STFail(@"Loading of questions failed with error: %@", error);
         }];
    }];
    
    Bet *bet = [result firstObject];
    STAssertEqualObjects(bet.remoteId, [NSNumber numberWithInt:1], @"Bet id is incorrect");
    STAssertEqualObjects(bet.membershipId, [NSNumber numberWithInt:3], @"Bet membershipId is incorrect");
    STAssertEqualObjects(bet.amount, [NSDecimalNumber decimalNumberWithString:@"5"], @"Bet amount is incorrect");
    STAssertEqualObjects(bet.probability, [NSDecimalNumber decimalNumberWithString:@"0.2"], @"Bet probability is incorrect");
    STAssertEqualObjects(bet.bonus, [NSDecimalNumber decimalNumberWithString:@"0.1"], @"Bet bonus is incorrect");
    
    STAssertEqualObjects([self.dateFormatter stringFromDate:bet.createdAt], @"2012-10-30T16:30:36Z", @"Bet createdAt is incorrect");
    STAssertEqualObjects([self.dateFormatter stringFromDate:bet.updatedAt], @"2012-10-30T16:35:36Z", @"Bet updatedAt is incorrect");
    STAssertEqualObjects(bet.answer.remoteId, [NSNumber numberWithInt:1], @"Bet answer is incorrect");
    STAssertEqualObjects(bet.answer.question.remoteId, [NSNumber numberWithInt:2], @"Bet question is incorrect");
}
/*
-(void)testCreateBet{
    Answer *answer = [Factories answerFactory];
    answer.currentProbability = [NSDecimalNumber decimalNumberWithString:@"0.25"];
    Membership *membership = [Factories membershipFactory];
    membership.user = [Factories userFactory];
    Bet *bet = [Bet object];
    membership.remoteId = [NSNumber numberWithInt:3];
    bet.membership = membership;
    bet.answer = answer;
    bet.probability = answer.currentProbability;
    bet.amount = [NSDecimalNumber decimalNumberWithString:@"5"];
    
    __block RKMappingResult *result;
    [RKTestNotificationObserver waitForNotificationWithName:RKObjectRequestOperationDidFinishNotification usingBlock:^{        
        [[RKObjectManager sharedManager] postObject:bet path:nil parameters:nil
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
            result = mappingResult;
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error){
            STFail(@"Creating bet failed with error: %@", error);
        }];
    }];
    
    STAssertEqualObjects(bet.probability, [NSDecimalNumber decimalNumberWithString:@"0.25"], @"Bet probability is incorrect");
    
    STAssertEqualObjects([self.dateFormatter stringFromDate:bet.createdAt], @"2012-11-09T20:03:01Z", @"Bet createdAt is incorrect");
    STAssertEqualObjects([self.dateFormatter stringFromDate:bet.updatedAt], @"2012-11-09T20:03:01Z", @"Bet updatedAt is incorrect");
    
    STAssertEqualObjects(bet.membership.outstandingBetsValue, [NSDecimalNumber decimalNumberWithString:@"30"], nil);
    STAssertEqualObjects(bet.membership.balance, [NSDecimalNumber decimalNumberWithString:@"9970"], nil);
}
*/
@end

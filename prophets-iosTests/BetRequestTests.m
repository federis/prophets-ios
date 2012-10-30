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
    STAssertEqualObjects(bet.leagueId, [NSNumber numberWithInt:3], @"Bet leagueId is incorrect");
    STAssertEqualObjects(bet.amount, [NSDecimalNumber decimalNumberWithString:@"5"], @"Bet amount is incorrect");
    STAssertEqualObjects(bet.probability, [NSDecimalNumber decimalNumberWithString:@"0.2"], @"Bet probability is incorrect");
    STAssertEqualObjects(bet.bonus, [NSDecimalNumber decimalNumberWithString:@"0.1"], @"Bet bonus is incorrect");
    
    STAssertEqualObjects([self.dateFormatter stringFromDate:bet.createdAt], @"2012-10-30T16:30:36Z", @"Bet createdAt is incorrect");
    STAssertEqualObjects([self.dateFormatter stringFromDate:bet.updatedAt], @"2012-10-30T16:35:36Z", @"Bet updatedAt is incorrect");
    STAssertEqualObjects(bet.answer.remoteId, [NSNumber numberWithInt:1], @"Bet answer is incorrect");
    STAssertEqualObjects(bet.answer.question.remoteId, [NSNumber numberWithInt:2], @"Bet question is incorrect");
}


@end

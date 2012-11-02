//
//  AnswerTest.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFLogicTest.h"
#import "Answer.h"
#import "Question.h"

@interface AnswerTests : FFLogicTest

@end

@implementation AnswerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

-(void)testIsCorrectSetter{
    Answer *answer = [Factories answerFactory];
    
    answer.isCorrect = YES;
    STAssertTrue([answer.correct intValue] == 1, @"Answer isCorrect setter did not correctly set true value");
    answer.isCorrect = NO;
    STAssertTrue([answer.correct intValue] == 0, @"Answer isCorrect setter did not correctly set false value");
}

-(void)testIsCorrectGetter{
    Answer *answer = [Factories answerFactory];
    
    answer.correct = [NSNumber numberWithBool:YES];
    STAssertTrue(answer.isCorrect, @"Answer isCorrect getter did not correctly get true value");
    answer.correct = [NSNumber numberWithBool:NO];
    STAssertTrue([answer.correct intValue] == 0, @"Answer isCorrect getter did not correctly get false value");
}

-(void)testBettingEndedAt{
    Answer *answer = [Factories answerFactory];
    answer.question = [Factories questionFactory];
    
    NSDate *now = [NSDate date];
    NSTimeInterval days = 3600 * 24;
    answer.question.approvedAt = [NSDate dateWithTimeInterval:-5*days sinceDate:now];
    answer.question.bettingClosesAt = [NSDate dateWithTimeInterval:10*days sinceDate:now];
    STAssertTrue(answer.isOpenForBetting, @"Answer should be open for betting");
    
    STAssertNil(answer.bettingEndedAt, @"Betting end should be nil when answer is open for betting");
    
    answer.judgedAt = [NSDate dateWithTimeInterval:-2*days sinceDate:now];
    STAssertEqualObjects(answer.bettingEndedAt, answer.judgedAt, @"Betting should have ended at the time of judgement");
    
    answer.correctnessKnownAt = [NSDate dateWithTimeInterval:-3*days sinceDate:now];
    STAssertEqualObjects(answer.bettingEndedAt, answer.correctnessKnownAt, @"Betting should have ended at the time correctness was known");
    
    answer.correctnessKnownAt = nil;
    answer.judgedAt = nil;
    answer.question.bettingClosesAt = [NSDate dateWithTimeInterval:-2*days sinceDate:now];
    STAssertEqualObjects(answer.bettingEndedAt, answer.question.bettingClosesAt, @"Betting should have ended at question's close of betting");
}

@end

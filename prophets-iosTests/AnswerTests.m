//
//  AnswerTest.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTestCase.h"
#import "Answer.h"

@interface AnswerTests : FFBaseTestCase

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
    [RKTestFactory managedObjectStore];
    Answer *answer = [Answer MR_createEntity];
    
    answer.isCorrect = YES;
    STAssertTrue([answer.correct intValue] == 1, @"Answer isCorrect setter did not correctly set true value");
    answer.isCorrect = NO;
    STAssertTrue([answer.correct intValue] == 0, @"Answer isCorrect setter did not correctly set false value");
}

-(void)testIsCorrectGetter{
    [RKTestFactory managedObjectStore];
    Answer *answer = [Answer MR_createEntity];
    
    answer.correct = [NSNumber numberWithBool:YES];
    STAssertTrue(answer.isCorrect, @"Answer isCorrect getter did not correctly get true value");
    answer.correct = [NSNumber numberWithBool:NO];
    STAssertTrue([answer.correct intValue] == 0, @"Answer isCorrect getter did not correctly get false value");
}

@end

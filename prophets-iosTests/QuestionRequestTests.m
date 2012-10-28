//
//  QuestionRequestTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/28/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFRequestTest.h"
#import "League.h"
#import "Question.h"

@interface QuestionRequestTests : FFRequestTest

@end

@implementation QuestionRequestTests

-(void)testGetLeagueQuestions{
    League *league = [Factories leagueFactory];
    __block RKMappingResult *result;
    
    [RKTestNotificationObserver waitForNotificationWithName:RKObjectRequestOperationDidFinishNotification usingBlock:^{
        [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"questions" ofObject:league parameters:nil
         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
             result = mappingResult;
         }
         failure:^(RKObjectRequestOperation *operation, NSError *error){
             STFail(@"Loading of questions failed with error: %@", error);
         }];
    }];
    
    Question *question = [result firstObject];
    STAssertEqualObjects(question.remoteId, [NSNumber numberWithInt:2], @"Question id is incorrect");
    STAssertEqualObjects(question.content, @"what is your question?", @"Question content is incorrect");
    STAssertEqualObjects(question.desc, @"this is my description", @"Question description is incorrect");
    
    STAssertEqualObjects([self.dateFormatter stringFromDate:question.createdAt], @"2012-10-25T13:23:51Z", @"Question createdAt is incorrect");
    STAssertEqualObjects([self.dateFormatter stringFromDate:question.updatedAt], @"2012-10-25T14:26:57Z", @"Question updatedAt is incorrect");
    STAssertEqualObjects([self.dateFormatter stringFromDate:question.approvedAt], @"2012-10-25T14:26:57Z", @"Question updatedAt is incorrect");
    STAssertEqualObjects(question.league.remoteId, [NSNumber numberWithInt:1], @"Question league is incorrect");
}


@end

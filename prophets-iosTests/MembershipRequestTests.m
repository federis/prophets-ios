//
//  MembershipRequestTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/27/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFRequestTest.h"
#import "Membership.h"
#import "League.h"

@interface MembershipRequestTests : FFRequestTest

@end


@implementation MembershipRequestTests

- (void)setUp{
    [super setUp];
    
}

- (void)tearDown{
    [super tearDown];
    
}

-(void)testGetMemberships{
    User *user = [Factories userFactory];
    __block RKMappingResult *result;
    
    [RKTestNotificationObserver waitForNotificationWithName:RKObjectRequestOperationDidFinishNotification usingBlock:^{
        [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"memberships" ofObject:user parameters:nil
         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
             result = mappingResult;
         }
         failure:^(RKObjectRequestOperation *operation, NSError *error){
             STFail(@"Failed to load memberships");
         }];
    }];
    
    Membership *membership = [result firstObject];
    STAssertEqualObjects(membership.remoteId, [NSNumber numberWithInt:1], @"Membership id is incorrect");
    STAssertEqualObjects(membership.role, [NSNumber numberWithInt:1], @"Membership role is incorrect");
    STAssertEqualObjects(membership.balance, [NSDecimalNumber numberWithInt:10000], @"Membership balance is incorrect");
    
    STAssertEqualObjects([self.dateFormatter stringFromDate:membership.createdAt], @"2012-10-01T01:32:30Z", @"Membership createdAt is incorrect");
    STAssertEqualObjects([self.dateFormatter stringFromDate:membership.updatedAt], @"2012-10-01T01:32:30Z", @"Membership updatedAt is incorrect");
    
    League *league = membership.league;
    STAssertEqualObjects(league.remoteId, [NSNumber numberWithInt:1], @"League id is incorrect");
    STAssertTrue(league.isPrivate, @"League should not be private");
    STAssertEqualObjects(league.maxBet, [NSNumber numberWithInt:1000], @"League max bet is incorrect");
    STAssertEqualObjects(league.initialBalance, [NSNumber numberWithInt:10000], @"League initial balance is incorrect");
    STAssertEqualObjects(league.name, @"the league 1", @"League name is incorrect");
    STAssertEqualObjects(league.membershipsCount, [NSNumber numberWithInt:2], @"League memberships count is incorrect");
    STAssertEqualObjects(league.questionsCount, [NSNumber numberWithInt:5], @"League questions count is incorrect");
    
    STAssertEqualObjects([self.dateFormatter stringFromDate:league.createdAt], @"2012-10-01T01:32:30Z", @"Membership createdAt is incorrect");
    STAssertEqualObjects([self.dateFormatter stringFromDate:league.updatedAt], @"2012-10-01T01:32:30Z", @"Membership createdAt is incorrect");
    
}


@end

//
//  UserRequestTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/27/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFRequestTest.h"
#import "User.h"

@interface UserRequestTests : FFRequestTest

@end

@implementation UserRequestTests

-(void)testUserTokenLoader{
    User *user = [User object];
    user.email = @"test@example.com";
    user.password = @"password";
    __block RKMappingResult *result;
    
    [RKTestNotificationObserver waitForNotificationWithName:RKObjectRequestOperationDidFinishNotification usingBlock:^{
        [[RKObjectManager sharedManager] postObject:user path:@"/tokens" parameters:nil
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                result = mappingResult;
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error){
                STFail(@"Loading token failed");
            }];
    }];
    
    User *u = [result firstObject];
    STAssertNotNil(u, @"Expected issue not to be nil");
    STAssertEqualObjects(u.name, @"Ben Roesch", @"User's name is incorrect");
    STAssertEqualObjects(u.remoteId, [NSNumber numberWithInt:1], @"User's id is incorrect");
    STAssertEqualObjects(u.email, @"bcroesch@gmail.com", @"User's email is incorrect");
    STAssertEqualObjects(u.authenticationToken, @"fAcHvsHHwo13kxFYeFLL", @"User's auth token is incorrect");
    
    STAssertEqualObjects([self.dateFormatter stringFromDate:u.createdAt], @"2012-08-10T00:12:17Z", @"User's createdAt date is incorrect");
    STAssertEqualObjects([self.dateFormatter stringFromDate:u.updatedAt], @"2012-09-26T17:25:06Z", @"User's updatedAt date is incorrect");
}

@end



//
//  UserTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFLogicTest.h"
#import "User.h"
#import "KeychainItemWrapper.h"
#import "FFApplicationConstants.h"

@interface UserTests : FFLogicTest

@end


@implementation UserTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}
/*
-(void)testCurrentUserGetter{
    User *user = [User currentUser];
    STAssertNil(user, @"Current user should be nil");
    
    user = [[User alloc] init];
    user.remoteId = 1;
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
    [keychain setObject:user.remoteId forKey:(__bridge id)kSecAttrAccount];
    
    User *currentUser = [User currentUser];
    STAssertNotNil(currentUser, @"Current user should not be nil");
    STAssertEqualObjects(currentUser.email, user.email, @"User email is incorrect");
}

-(void)testCurrentUserSetter{
    User *currentUser = [User currentUser];
    STAssertNil(currentUser, @"Current user should be nil");
    
    User *newUser = [Factories userFactory];
    [User setCurrentUser:newUser];
    
    //need a fresh kc instance for some reason, otherwise we don't get the change set in setCurrentUser
    KeychainItemWrapper* kc = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
    NSNumber *userId = [kc objectForKey:(__bridge id)kSecAttrAccount];
    STAssertEqualObjects(userId, newUser.remoteId, @"User id not set properly in the keychain");
    
    User *foundUser = [User findById:userId];
    STAssertEqualObjects(foundUser, newUser, @"Current User object not found properly");
    
    STAssertEqualObjects([User currentUser], foundUser, @"Current user not set properly");
} 
*/


@end

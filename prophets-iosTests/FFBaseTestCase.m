//
//  FFBaseTestCase.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/4/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTestCase.h"
#import "FFObjectManager.h"
#import "User.h"

@implementation FFBaseTestCase

- (void)setUp{
    [RKTestFactory setUp];
    
    [FFObjectManager setupObjectManager];
    
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
    
    [User setCurrentUser:nil];
    
    [keychain resetKeychainItem];
    keychain = nil;
}

@end

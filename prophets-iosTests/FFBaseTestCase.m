//
//  FFBaseTestCase.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/4/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTestCase.h"
#import "FFMappingProvider.h"
#import "User.h"

@implementation FFBaseTestCase

- (void)setUp{
    [RKTestFactory setUp];
    [RKTestFactory clearCacheDirectory];
    
    RKObjectManager *manager = [RKTestFactory objectManager];
    manager.objectStore = [RKTestFactory managedObjectStore];
    manager.mappingProvider = [FFMappingProvider mappingProviderWithObjectStore:manager.objectStore];
    
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
    [RKTestFactory clearCacheDirectory];
    
    [User setCurrentUser:nil];
    
    [keychain resetKeychainItem];
    keychain = nil;
}

@end

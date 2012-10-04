//
//  User.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;
static NSString *keychainIdentifier = @"prophets-ios";

@synthesize password = _password;

@dynamic userId;
@dynamic email;
@dynamic name;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic answers;
@dynamic judgedAnswers;
@dynamic bets;
@dynamic createdLeagues;
@dynamic memberships;
@dynamic questions;
@dynamic approvedQuestions;

+(User *)currentUser{
    if(!currentUser){
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:keychainIdentifier accessGroup:nil];
        NSNumber *userId = [keychain objectForKey:(__bridge id)kSecAttrAccount];
        currentUser = [User findByPrimaryKey:userId];
    }
    
    return currentUser;
}

+(void)setCurrentUser:(User *)user{
    currentUser = user;
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:keychainIdentifier accessGroup:nil];
    if(!user)
        [keychain resetKeychainItem];
    else
        [keychain setObject:user.userId forKey:(__bridge id)kSecAttrAccount];
}

-(NSString *)authenticationToken{
    if(!_authenticationToken){
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:keychainIdentifier accessGroup:nil];
        _authenticationToken = [keychain objectForKey:(__bridge id)kSecValueData];
    }
    return _authenticationToken;
}

-(void)setAuthenticationToken:(NSString *)token{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:keychainIdentifier accessGroup:nil];
    [keychain setObject:token forKey:(__bridge id)kSecValueData];
    _authenticationToken = token;
}



@end

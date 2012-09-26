//
//  User.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "User.h"

@implementation User

static User  *currentUser = nil;

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
    return currentUser;
}

+(void)setCurrentUser:(User *)user{
    currentUser = user;
}

-(NSString *)authenticationToken{
    if(!_authenticationToken){
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"prophets-ios" accessGroup:nil];
        _authenticationToken = [keychain objectForKey:(__bridge id)kSecValueData];
    }
    return _authenticationToken;
}

-(void)setAuthenticationToken:(NSString *)token{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"prophets-ios" accessGroup:nil];
    [keychain setObject:token forKey:(__bridge id)kSecValueData];
    _authenticationToken = token;
}



@end

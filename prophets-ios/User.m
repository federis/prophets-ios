//
//  User.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "User.h"
#import "KeychainItemWrapper.h"
#import "ApplicationConstants.h"
#import "CoreData+MagicalRecord.h"

@implementation User

static User *currentUser = nil;

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
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
        NSNumber *userId = [keychain objectForKey:(__bridge id)kSecAttrAccount];
        currentUser = [[User MR_findByAttribute:@"userId" withValue:userId] lastObject];
    }
    
    return currentUser;
}

+(void)setCurrentUser:(User *)user{
    currentUser = user;
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
    if(!user)
        [keychain resetKeychainItem];
    else
        [keychain setObject:user.userId forKey:(__bridge id)kSecAttrAccount];
}

-(NSString *)authenticationToken{
    if(!_authenticationToken){
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
        _authenticationToken = [keychain objectForKey:(__bridge id)kSecValueData];
    }
    return _authenticationToken;
}

-(void)setAuthenticationToken:(NSString *)token{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
    [keychain setObject:token forKey:(__bridge id)kSecValueData];
    _authenticationToken = token;
}

+(RKEntityMapping *)entityMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"email", @"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id" : @"userId",
        @"authentication_token" : @"authenticationToken",
        @"updated_at" : @"updatedAt",
        @"created_at" : @"createdAt"
     }];
    
    return mapping;
}



@end

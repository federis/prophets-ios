//
//  User.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "User.h"
#import "KeychainItemWrapper.h"
#import "FFApplicationConstants.h"
#import "Membership.h"
#import "League.h"
#import "NSManagedObjectContext+Additions.h"

@implementation User

static User *currentUser = nil;

@synthesize password = _password;

@dynamic email;
@dynamic name;
@dynamic answers;
@dynamic judgedAnswers;
@dynamic bets;
@dynamic createdLeagues;
@dynamic memberships;
@dynamic questions;
@dynamic approvedQuestions;


-(Membership *)membershipInLeague:(NSNumber *)leagueId{
    NSParameterAssert(leagueId);
    
    NSSet *objs = [self.managedObjectContext fetchObjectsForEntityName:NSStringFromClass([Membership class])
                                                         withPredicate:@"leagueId = %@ AND userId = %@", leagueId, self.remoteId];
    
    return [objs anyObject]; //should only be 1
}

+(User *)currentUser{
    if(!currentUser){
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
        NSNumber *remoteId = [keychain objectForKey:(__bridge id)kSecAttrAccount];
        currentUser = [User findById:remoteId];
    }
    
    return currentUser;
}

+(void)setCurrentUser:(User *)user{
    currentUser = user;
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:FFKeychainIdentifier accessGroup:nil];
    if(!user)
        [keychain resetKeychainItem];
    else
        [keychain setObject:user.remoteId forKey:(__bridge id)kSecAttrAccount];
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

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"email", @"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id" : @"remoteId",
        @"authentication_token" : @"authenticationToken",
        @"updated_at" : @"updatedAt",
        @"created_at" : @"createdAt"
     }];
    
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromArray:@[@"email", @"name", @"password"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"remoteId" : @"id"
     }];
    return mapping;
}


@end
